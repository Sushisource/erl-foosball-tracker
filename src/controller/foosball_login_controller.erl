-module(foosball_login_controller, [Req]).
-compile(export_all).
-default_action(login).

login('POST', []) ->
  case Req:request_body() of
    <<"loginName=", LoginName/binary>> ->
      FoundPlayer = boss_db:find(fb_player, [name = LoginName]),
      PlayerExists = case FoundPlayer of
                       [] ->
                         NewUser = fb_player:new(id, binary_to_list(LoginName)),
                         case NewUser:save() of
                           {ok, NewUserRec} -> NewUserRec;
                           _ -> error
                         end;
                       _ -> true
                     end,
      {json, [{response, PlayerExists}]}
  end.
