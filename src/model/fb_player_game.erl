-module(fb_player_game, [Id, FbGameId, FbPlayerId, Team::string()]).
-belongs_to(fb_game).
-belongs_to(fb_player).
-has({fb_scores, many}).
-compile(export_all).

inprog() ->
  Game = fb_game(),
  Game:inprog().

endgame() ->
  Game = fb_game(),
  EndedGame = Game:set(inprog, false),
  EndedGame:save().

would_be_final_score() ->
  Game = fb_game(),
  Scores = Game:team_scores(Team),
  length(Scores) >= 7.
