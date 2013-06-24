-module(foosball_game_controller, [Req]).
-compile(export_all).
-default_action(list).

info('GET', [Id]) ->
  Game = boss_db:find(Id),
  PlayerGames = Game:fb_player_games(),
  Players = lists:map(fun(X) -> X:fb_player() end, PlayerGames),
  {json, [{this, Game}, {players, Players}]}.

