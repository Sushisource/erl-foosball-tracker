-module(fb_game, [Id, Date :: datetime(), Inprog :: boolean(), Historical :: boolean()]).
-has({fb_player_games, many}).
-has({fb_scores, many}).
-has({fb_historical_game, 1}).
-compile(export_all).

team_scores(Teamname) ->
  % Historical games will just return a number, interactive games will return
  % a list of scores
  if
    Historical ->
      HGame = fb_historical_game(),
      WinS = HGame:winscore(),
      LoseS = HGame:loserscore(),
      case HGame:winteam() of
        Teamname ->
          WinS;
        _ ->
          LoseS
      end;
    true ->
      PGames = fb_player_games(),
      OnTeam = [PG || PG <- PGames, PG:team() == Teamname],
      lists:flatten([PG:fb_scores() || PG <- OnTeam])
  end.

score_totals() ->
  YS = team_scores("yellow"),
  BS = team_scores("black"),
  {YS2, BS2} = if
                 Historical ->
                   {YS, BS};
                 true ->
                   {length(YS), length(BS)}
               end,
  [{yellow, YS2}, {black, BS2}].
