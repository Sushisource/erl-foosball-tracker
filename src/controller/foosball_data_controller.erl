-module(foosball_data_controller, [Req]).
-compile(export_all).
-default_action(list).

read('GET', [Model, Id]) ->
  Results = boss_db:find(list_to_atom(Model), [id = Id]),
  {json, Results}.

list('GET', [Model]) ->
  Args = case Model of
    "fb_game" -> [{inprog, 'equals', Req:query_param("inprog", false)}];
    otherwise -> []
  end,
  Results = boss_db:find(list_to_atom(Model), Args),
  {json, Results}.

list('GET') ->
  {json, []}.

