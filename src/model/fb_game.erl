-module(fb_game, [Id, Date::datetime(), Inprog::boolean(), Historical::boolean()]).
-has({fb_player_games, many}).
-has({fb_scores, many}).
-compile(export_all).

team_scores(Teamname) ->
  %TODO: Use Historical to pull scores properly
  PGames = fb_player_games(),
  OnTeam = [PG || PG <- PGames, PG:team() == Teamname],
  Scores = lists:flatten([PG:fb_scores() || PG <- OnTeam]),
  Scores.
