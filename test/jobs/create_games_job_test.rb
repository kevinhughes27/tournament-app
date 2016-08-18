require 'test_helper'

class CreateGamesJobTest < ActiveJob::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @division = divisions(:open)
    @division.games.destroy_all
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

    game = Game.find_by(division: @division, bracket_uid: template_game[:bracket_uid])

    assert game
    assert_equal template_game[:home_prereq].to_s, game.home_prereq
    assert_equal template_game[:away_prereq].to_s, game.away_prereq
  end
end
