-module(foosball_game_controller, [Req]).
-export([info/2, score/2, game/2]).
-default_action(game).

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

game('GET', [Id]) ->
  info('GET', [Id]).

score('POST', []) ->
  ScoreData = helpers:json2proplist(Req:request_body()),
  % Get which game we're in and find if this is the last point
  GameID = proplists:get_value(fb_game_id, ScoreData),
  PlayerID = proplists:get_value(fb_player_id, ScoreData),
  PlGame = helpers:find_plgame(GameID, PlayerID),
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

