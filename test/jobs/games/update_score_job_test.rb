require 'test_helper'

module Games
  class UpdateScoreJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @division = divisions(:open)
      @home = teams(:swift)
      @away = teams(:goose)
      @game = games(:swift_goose)
    end

    test "can't update_score for pool game if winner changes and pool is already finished" do
      @game.update_column(:pool, 'A')
      Divisions::UpdatePoolJob.expects(:perform_later)
      assert Games::UpdateScoreJob.perform_now(game: @game, home_score: 15, away_score: 11)
      refute Games::UpdateScoreJob.perform_now(game: @game, home_score: 11, away_score: 15)
    end

    test "can update_score for pool game if pool is already finished but winner doesn't change" do
      @game.update_column(:pool, 'A')
      Divisions::UpdatePoolJob.expects(:perform_later).twice
      assert Games::UpdateScoreJob.perform_now(game: @game, home_score: 15, away_score: 11)
      assert Games::UpdateScoreJob.perform_now(game: @game, home_score: 14, away_score: 11)
    end

    test "can't update score unless teams" do
      game = games(:semi_final)
      refute game.teams_present?
      Games::UpdateScoreJob.perform_now(game: game, home_score: 10, away_score: 5)
      assert_nil game.score
    end

    test "update_score confirms the game" do
      @game.stubs(:update_bracket)
      Games::UpdateScoreJob.perform_now(game: @game, home_score: 15, away_score: 11)
      assert @game.confirmed?
    end

    test "can't update_score if dependent games are scored" do
      game1 = Game.create!(
        tournament: @tournament,
        division: @division,
        bracket_uid: 'q1',
        home_prereq_uid: '1',
        away_prereq_uid: '2',
        home: @home,
        away: @away
      )

      game2 = Game.create!(
        tournament: @tournament,
        division: @division,
        bracket_uid: 's1',
        home_prereq_uid: 'Wq1',
        away_prereq_uid: 'Wq2'
      )

      Games::UpdateScoreJob.perform_now(game: game1, home_score: 15, away_score: 11)
      game2.update_column(:score_confirmed, true)
      refute Games::UpdateScoreJob.perform_now(game: game1, home_score: 11, away_score: 15)
    end

    test "can update_score if winner doesn't change but dependent games are scored" do
      game1 = Game.create!(
        tournament: @tournament,
        division: @division,
        bracket_uid: 'q1',
        home_prereq_uid: '1',
        away_prereq_uid: '2',
        home: @home,
        away: @away
      )

      game2 = Game.create!(
        tournament: @tournament,
        division: @division,
        bracket_uid: 's1',
        home_prereq_uid: 'Wq1',
        away_prereq_uid: 'Wq2'
      )

      Games::UpdateScoreJob.perform_now(game: game1, home_score: 15, away_score: 11)
      game2.update_column(:score_confirmed, true)
      assert Games::UpdateScoreJob.perform_now(game: game1, home_score: 14, away_score: 11)
    end

    test "update_score sets the score if no previous score" do
      game = games(:swift_goose_no_score)
      game.stubs(:update_bracket)
      Games::SetScoreJob.expects(:perform_now)
      Games::UpdateScoreJob.perform_now(game: game, home_score: 15, away_score: 11)
    end

    test "update_score adjusts the score if game already has a score" do
      @game.stubs(:update_bracket)
      Games::AdjustScoreJob.expects(:perform_now)
      Games::UpdateScoreJob.perform_now(game: @game, home_score: 14, away_score: 12)
    end
  end
end
