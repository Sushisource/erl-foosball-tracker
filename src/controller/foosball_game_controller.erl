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
  {struct, Body} = mochijson2:decode(Req:request_body()), % Parse JSON
  Normalize = fun({K, <<V/binary>>}) ->
    {binary_to_atom(K, utf8), binary_to_list(V)}
  end,
  Normalized = lists:map(Normalize, Body),
  NewScore = boss_record:new(fb_score, Normalized), % Make it into a score
  case NewScore:save() of
    {ok, NewScoreRec} -> {json, NewScoreRec};
    {error, Errors} -> {json, [{errors, Errors}]}
  end.
