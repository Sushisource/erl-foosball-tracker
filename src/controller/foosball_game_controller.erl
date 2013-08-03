-module(foosball_game_controller, [Req]).
-export([game/2]).
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
  {json, [{this, Game}, {players, Players}]}.

