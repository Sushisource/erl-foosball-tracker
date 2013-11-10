-module(foosball_game_controller, [Req]).
-compile(export_all).
-default_action(game).

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
  Game = fb_game:new(id, calendar:now_to_datetime(now()), InProgress),
  {ok, NuGame} = Game:save(),
  {json, NuGame}.
