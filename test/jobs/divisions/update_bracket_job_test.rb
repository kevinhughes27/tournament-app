require 'test_helper'

module Divisions
  class UpdateBracketJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @division = divisions(:open)
      @home = teams(:swift)
      @away = teams(:goose)
    end

    test "game pushes its winner through the bracket when its score is confirmed" do
      game1 = Game.create(tournament: @tournament, division: @division, bracket_uid: 'q1', home_prereq_uid: '1', away_prereq_uid: '2', home: @home, away: @away)
      game2 = Game.create(tournament: @tournament, division: @division, bracket_uid: 'q1', home_prereq_uid: 'Wq1', away_prereq_uid: 'Wq2')

      game1.update_columns(home_score: 15, away_score: 11)
      UpdateBracketJob.perform_now(game_id: game1.id)

      assert_equal @home, game2.reload.home
    end

    test "game pushes its loser through the bracket when its score is confirmed" do
      game1 = Game.create(tournament: @tournament, division: @division, bracket_uid: 'q1', home_prereq_uid: '1', away_prereq_uid: '2', home: @home, away: @away)
      game2 = Game.create(tournament: @tournament, division: @division, bracket_uid: 'q1', home_prereq_uid: 'Lq2', away_prereq_uid: 'Lq1')

      game1.update_columns(home_score: 15, away_score: 11)
      UpdateBracketJob.perform_now(game_id: game1.id)

      assert_equal @away, game2.reload.away
    end
  end
end
