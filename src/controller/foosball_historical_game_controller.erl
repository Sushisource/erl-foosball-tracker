-module(foosball_historical_game_controller, [Req]).
-export([historical_game/2]).
-default_action(historical_game).

historical_game('POST', []) ->
  Data = helpers:json2proplist(Req:request_body()),
  WinPlayers = proplists:get_value(win_players, Data),
  LosePlayers = proplists:get_value(lose_players, Data),
  WinScore = proplists:get_value(win_score, Data),
  LoseScore = proplists:get_value(lose_score, Data),
  % Winning team name
  Winner = proplists:get_value(winner, Data),
  Loser = proplists:get_value(loser, Data),
  % We will automatically greate a new game first, and then associate
  % a historical game with it, and the necessary playergames
  NuGame = fb_game:new(id, calendar:now_to_datetime(now()), false, true),
  {ok, RetGame} = NuGame:save(),
  HistGame = fb_historical_game:new(id, RetGame:id(), WinScore, LoseScore, Winner),
  PGameMaker = fun(Plid, TeamName) ->
    fb_player_game:new(id, RetGame:id(), Plid, TeamName)
  end,
  lists:map(fun(I) -> PGameMaker(I, Winner) end, WinPlayers),
  lists:map(fun(I) -> PGameMaker(I, Loser) end, LosePlayers),
  %fb_player_game:new(id, RetGame:id(), 
  {json, [{game, RetGame}]};

historical_game('GET', []) ->
  % STUBBED
  Params = Req:query_params(),
  {json, [Params]}.
