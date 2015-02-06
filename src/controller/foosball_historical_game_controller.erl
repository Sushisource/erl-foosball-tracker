-module(foosball_historical_game_controller, [Req]).
-export([historical_game/2]).
-default_action(historical_game).

historical_game('POST', []) ->
  Data = helpers:json2proplist(Req:request_body()),
  YellowPlayers = proplists:get_value(yellow_players, Data),
  BlackPlayers = proplists:get_value(black_players, Data),
  YellowScore = proplists:get_value(yellow_score, Data),
  BlackScore = proplists:get_value(black_score, Data),
  {WinScore, LoseScore, Winner, Loser} = case YellowScore > BlackScore of
    true ->
      {YellowScore, BlackScore, "yellow", "black"};
    false ->
      {BlackScore, YellowScore, "black", "yellow"}
  end,
  % We will automatically greate a new game first, and then associate
  % a historical game with it, and the necessary playergames
  NuGame = fb_game:new(id, calendar:now_to_datetime(now()), false, true),
  {ok, RetGame} = NuGame:save(),
  HistGame = fb_historical_game:new(id, RetGame:id(), WinScore, LoseScore, Winner),
  {ok, _} = HistGame:save(),
  PGameMaker = fun(Plid, TeamName) ->
    NuPGame = fb_player_game:new(id, RetGame:id(), Plid, TeamName),
    NuPGame:save()
  end,
  lists:foreach(fun(I) -> PGameMaker(I, Winner) end, YellowPlayers),
  lists:foreach(fun(I) -> PGameMaker(I, Loser) end, BlackPlayers),
  {json, [{game, RetGame}]};

historical_game('GET', []) ->
  % STUBBED
  Params = Req:query_params(),
  Mat = [[1,2,3],
         [3,4,5]],
  {json, [matrix:transpose(Mat)]}.
