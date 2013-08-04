-module(foosball_ingame_websocket).
-behaviour(boss_service_handler).
-export([init/0,
  handle_incoming/5,
  handle_join/4,
  handle_close/4,
  handle_broadcast/2,
  handle_info/2,
  terminate/2]).

init() ->
  {ok, []}.

handle_join(ServiceURL, WebSocket, SessionId, State) ->
  {reply, ok, State}.

handle_close(ServiceURL, WebSocket, SessionId, State) ->
  {reply, ok, State}.

handle_incoming(ServiceURL, WebSocket, SessionId, Message, State) ->
  {reply, Message, State}.

handle_broadcast(Message, State) ->
  {noreply, State}.

handle_info(Info, State) ->
  {noreply, State}.

terminate(Reason, State) -> ok.
