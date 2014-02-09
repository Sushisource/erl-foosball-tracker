-module(helpers).
-compile(export_all).

normalizr({K, <<V/binary>>}) ->
    {binary_to_atom(K, utf8), binary_to_list(V)};
normalizr({K, Other}) when is_list(Other) ->
  {binary_to_atom(K, utf8), [binary_to_list(X) || X <- Other]};
normalizr({K, Other}) ->
  {binary_to_atom(K, utf8), Other}.

% Parses JSON into a proplist with atom/str k/v
json2proplist(RequstBody) ->
  {struct, Body} = mochijson2:decode(RequstBody),
  Normalize = fun(Tuple) ->
    normalizr(Tuple)
  end,
  lists:map(Normalize, Body).

find_plgame(GameID, PlayerID) ->
  boss_db:find_first(fb_player_game,
    [{fb_game_id, 'equals', GameID}, {fb_player_id, 'equals', PlayerID}]).
