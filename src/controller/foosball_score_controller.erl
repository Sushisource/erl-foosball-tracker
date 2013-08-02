-module(foosball_score_controller, [Req]).
-export([score/2]).
-default_action(score).

score('POST', []) ->
  ScoreData = helpers:json2proplist(Req:request_body()),
  % Get which game we're in and find if this is the last point
  GameID = proplists:get_value(fb_game_id, ScoreData),
  PlayerID = proplists:get_value(fb_player_id, ScoreData),
  PlGame = helpers:find_plgame(GameID, PlayerID),
  InProgress = PlGame:inprog(),
  case InProgress of
  % There's no point if the game is already over
    false ->
      {json, [{error, "Game is already over"}]};
    true ->
      LastScore = PlGame:would_be_final_score(),
      NewScore = fb_score:new(id,
        PlGame:id(), proplists:get_value(pos, ScoreData)),
      % save the score
      {ok, NewScoreRec} = NewScore:save(),
      % If this is the last score, close the game and save it.
      {ok, _} = if
        LastScore == true ->
          PlGame:endgame();
        true ->
          {ok, whatever}
      end,
      {json, NewScoreRec}
  end.

