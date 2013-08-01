-module(foosball_game_controller, [Req]).
-export([info/2, score/2, joingame/2]).
-default_action(list).

info('GET', [Id]) ->
  Game = boss_db:find(Id),
  % For extracting the player from the player game, and putting in team info
  PlayerMaker = fun(PGame) ->
    Player = PGame:fb_player(),
    Attribs = Player:attributes(),
    [{team, PGame:team()} | Attribs]
  end,
  PlayerGames = Game:fb_player_games(),
  Players = lists:map(PlayerMaker, PlayerGames),
  {json, [{this, Game}, {players, Players}]}.

% Parses JSON into a proplist with atom/str k/v
json2proplist(RequstBody) ->
  {struct, Body} = mochijson2:decode(RequstBody),
  Normalize = fun({K, <<V/binary>>}) ->
    {binary_to_atom(K, utf8), binary_to_list(V)}
  end,
  lists:map(Normalize, Body).

find_plgame(GameID, PlayerID) ->
  boss_db:find_first(fb_player_game,
    [{fb_game_id, 'equals', GameID}, {fb_player_id, 'equals', PlayerID}]).

score('POST', []) ->
  ScoreData = json2proplist(Req:request_body()),
  % Get which game we're in and find if this is the last point
  GameID = proplists:get_value(fb_game_id, ScoreData),
  PlayerID = proplists:get_value(fb_player_id, ScoreData),
  PlGame = find_plgame(GameID, PlayerID),
  InProgress = PlGame:inprog(),
  case InProgress of
  % There's no point if the game is already over
    false ->
      {json, [{error, "Game is already over"}]};
    true ->
      LastScore = PlGame:would_be_final_score(),
      NewScore = fb_score:new(id,
        PlGame:id(), proplists:get_value(pos, ScoreData)),
      % save the score
      {ok, NewScoreRec} = NewScore:save(),
      % If this is the last score, close the game and save it.
      {ok, _} = if
        LastScore == true ->
          PlGame:endgame();
        true ->
          {ok, whatever}
      end,
      {json, NewScoreRec}
  end.

joingame('POST', []) ->
  Data = json2proplist(Req:request_body()),
  GameID = proplists:get_value(fb_game_id, Data),
  PlayerID = proplists:get_value(fb_player_id, Data),
  Team = proplists:get_value(team, Data),
  PlGame = find_plgame(GameID, PlayerID),
  RetGame = case PlGame of
              undefined ->
                % Create and save new player game
                NuPlGame = fb_player_game:new(id, GameID, PlayerID, Team),
                {ok, Saved} = NuPlGame:save(),
                Saved;
              _ ->
                PlGame
            end,
  {json, [{game, RetGame}]}.

