-module(foosball_game_controller, [Req]).
-compile(export_all).
-default_action(game).

game('GET', []) ->
  Conditions = case Req:query_param("inprog") of
                 Val when Val == "true" orelse Val == "false" ->
                   [{inprog, 'equals', list_to_atom(Val)}];
                 _ ->
                   []
               end,
  Options = case Req:query_param("limit") of
              undefined -> [];
              Number -> [{limit, list_to_integer(Number)}]
            end ++ [{order_by, date}, {descending, true}],
  Results = boss_db:find(fb_game, Conditions, Options),
  ExpGames = lists:map(fun expand_game/1, Results),
  % This is kind of silly. I can't just return {json, ExpGames} because the
  % encoder doesn't understand being given a list directly.
  {json, [{games, ExpGames}]};

game('GET', [Id]) ->
  Game = boss_db:find(Id),
  % For extracting the player from the player game, and putting in team info
  PlayerMaker = fun(PGame) ->
    Player = PGame:fb_player(),
    Attribs = Player:attributes(),
    [{team, PGame:team()} | Attribs]
  end,
  PlayerGames = Game:fb_player_games(),
  Players = lists:map(PlayerMaker, PlayerGames),
  {json, [{this, Game}, {players, Players}]};

% Creates a new Game with current timestamp
game('POST', []) ->
  Data = helpers:json2proplist(Req:request_body()),
  InProgress = proplists:get_value(inprog, Data),
  Game = fb_game:new(id, calendar:now_to_datetime(now()), InProgress, false),
  {ok, NuGame} = Game:save(),
  {json, NuGame}.

% Given a Game record, will add it's players and score to the object
expand_game(Game) ->
  PlayerGames = Game:fb_player_games(),
  % For extracting the player from the player game, and putting in team info
  PlayerMaker = fun(PGame) ->
    Player = PGame:fb_player(),
    Attribs = Player:attributes(),
    [{team, PGame:team()} | Attribs]
  end,
  Players = lists:map(PlayerMaker, PlayerGames),
  {struct, NuGame} = boss_model_manager:to_json(Game),
  NuGame ++ [{players, Players}].

