-module(fb_game, [Id, Date::datetime(), Inprog::boolean()]).
-has({fb_player_games, many}).
-has({fb_scores, many}).
-compile(export_all).

team_scores(Teamname) ->
  PGames = fb_player_games(),
  OnTeam = [PG || PG <- PGames, PG:team() == Teamname],
  Scores = lists:flatten([PG:fb_scores() || PG <- OnTeam]),
  Scores.
