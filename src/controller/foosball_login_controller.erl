-module(foosball_login_controller, [Req]).
-compile(export_all).
-default_action(login).

login('POST', []) ->
  case Req:request_body() of
    <<"loginName=", LoginName/binary>> ->
      FoundPlayer = boss_db:find(fb_player, [name = LoginName]),
      Response = case FoundPlayer of
                   [] ->
                     NewUser = fb_player:new(id, binary_to_list(LoginName)),
                     case NewUser:save() of
                       {ok, NewUserRec} -> [{player, NewUserRec}];
                       _ -> [{error, "Error adding user"}]
                     end;
                   [ExistingPlayer] ->
                     [{exists, true}, {player, ExistingPlayer}]
                 end,
      {json, Response}
  end.
