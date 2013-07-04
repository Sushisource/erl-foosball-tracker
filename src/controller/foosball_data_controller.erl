-module(foosball_data_controller, [Req]).
-compile(export_all).
-default_action(list).

read('GET', [Model, Id]) ->
  Results = boss_db:find(list_to_atom(Model), [id = Id]),
  {json, Results}.

list('GET', [Model]) ->
  Args = case Req:query_param("filter") of
    String -> [Col, Op, Val] = string:tokens(String, " "),
              [{list_to_atom(Col), list_to_atom(Op), Val}];
    undefined -> []
  end,
  Results = boss_db:find(list_to_atom(Model), Args),
  {json, Results}.

list('GET') ->
  {json, []}.
