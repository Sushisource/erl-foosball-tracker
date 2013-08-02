-module(foosball_player_game_controller, [Req]).
-export([player_game/2]).
-default_action(player_game).

player_game('POST', []) ->
  Data = helpers:json2proplist(Req:request_body()),
  GameID = proplists:get_value(fb_game_id, Data),
  PlayerID = proplists:get_value(fb_player_id, Data),
  Team = proplists:get_value(team, Data),
  PlGame = helpers:find_plgame(GameID, PlayerID),
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
