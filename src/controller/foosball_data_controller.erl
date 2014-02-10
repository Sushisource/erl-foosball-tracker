-module(foosball_data_controller, [Req]).
-compile(export_all).
-default_action(list).

read('GET', [Model, Id]) ->
  Results = boss_db:find(list_to_atom(Model), [id = Id]),
  {json, Results}.

list('GET', [Model]) ->
  Args = case Req:query_param("filter") of
           undefined -> [];
           String -> [Col, Op, Val] = string:tokens(String, " "),
             [{list_to_atom(Col), list_to_atom(Op), Val}]
         end,
  Options = case Req:query_param("limit") of
              undefined -> [];
              Amount -> [{limit, list_to_integer(Amount)},
                         {order_by, date}, {descending, true}]
            end,
  Results = boss_db:find(list_to_atom(Model), Args, Options),
  {json, Results}.
