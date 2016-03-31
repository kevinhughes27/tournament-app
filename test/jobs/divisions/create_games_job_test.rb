require 'test_helper'

module Divisions
  class CreateGamesJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @division = divisions(:open)
    end

    test "creates games as spec'd by the bracket template" do
      type = 'single_elimination_8'
      template = Bracket.find_by(handle: type).template
      template_game = template[:games].first

      CreateGamesJob.perform_now(
        tournament_id: @tournament.id,
        division_id: @division.id,
        template: template
      )

      game = Game.find_by(division: @division, bracket_uid: template_game[:uid])

      assert game
      assert_equal template_game[:home].to_s, game.home_prereq_uid
      assert_equal template_game[:away].to_s, game.away_prereq_uid
    end
  end
end
