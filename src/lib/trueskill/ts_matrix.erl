%%%-------------------------------------------------------------------
%%% @author sjudge
%%% @doc
%%%
%%% @end
%%% Created : 06. Feb 2015 3:13 PM
%%%-------------------------------------------------------------------
-module(ts_matrix).
-author("sjudge").

%% API
-export([transpose/1]).

-type matrix() :: [[number(), ...]].

-spec new(matrix()) -> matrix().
transpose([[] | _]) -> [];
transpose(M) ->
  [lists:map(fun hd/1, M) | transpose(lists:map(fun tl/1, M))].