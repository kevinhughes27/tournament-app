require 'test_helper'

module Divisions
  class ChangeBracketJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @division = divisions(:open)
    end

    test "re-creates games as spec'd by the bracket template" do
      type = 'single_elimination_4'
      template = Bracket.find_by(handle: type).template
      template_game = template[:games].first

      ChangeBracketJob.perform_now(
        tournament_id: @tournament.id,
        division_id: @division.id,
        new_template: template
      )

      game = Game.find_by(division: @division, bracket_uid: template_game[:uid])

      assert game
      assert_equal template_game[:home].to_s, game.home_prereq_uid
      assert_equal template_game[:away].to_s, game.away_prereq_uid
    end

    test "games that are the same before and after are unaffected" do
      type = 'single_elimination_4'
      template = Bracket.find_by(handle: type).template
      template_game = template[:games].first

      field = fields(:upi1)

      game = Game::create_from_template!(
        tournament_id: @tournament.id,
        division_id: @division.id,
        template_game: template_game
      )

      game.update_columns(field_id: field.id)

      ChangeBracketJob.perform_now(
        tournament_id: @tournament.id,
        division_id: @division.id,
        new_template: template
      )

      game.reload
      assert_equal field, game.field
    end
  end
end
