require 'test_helper'

module Divisions
  class UpdatePlacesJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @division = divisions(:open)
      @home = teams(:swift)
      @away = teams(:goose)
    end

    test "game pushes its winner to a place when its score is confirmed" do
      game = Game.create!(
        tournament: @tournament,
        division: @division,
        round: 1,
        bracket_uid: 'q1',
        home_prereq: '1',
        away_prereq: '2',
        home: @home,
        away: @away
      )

      place = Place.create!(
        tournament: @tournament,
        division: @division,
        prereq: 'Wq1',
        position: 1
      )

      game.update_columns(home_score: 15, away_score: 11)
      UpdatePlacesJob.perform_now(game_id: game.id)

      assert_equal @home, place.reload.team
    end

    test "game pushes its loser to a place when its score is confirmed" do
      game = Game.create!(
        tournament: @tournament,
        division: @division,
        round: 1,
        bracket_uid: 'q1',
        home_prereq: '1',
        away_prereq: '2',
        home: @home,
        away: @away
      )

      place = Place.create!(
        tournament: @tournament,
        division: @division,
        prereq: 'Lq1',
        position: 2
      )

      game.update_columns(home_score: 15, away_score: 11)
      UpdatePlacesJob.perform_now(game_id: game.id)

      assert_equal @away, place.reload.team
    end
  end
end
