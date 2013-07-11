-module(foosball_game_controller, [Req]).
-compile(export_all).
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

score('POST', []) ->
  case Req:request_body() of
    LoginName ->
      {json, [{response, LoginName}]}
  end.
