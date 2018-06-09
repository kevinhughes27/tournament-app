require 'test_helper'

class UnassignGamesJobTest < ActiveJob::TestCase
  test "removes the team from all games (home)" do
    tournament = FactoryBot.create(:tournament)
    game = FactoryBot.create(:game)
    team = game.home

    UnassignGamesJob.perform_now(
      tournament_id: tournament.id,
      team_id: team.id
    )

    assert_nil game.reload.home
  end

  test "removes the team from all games (away)" do
    tournament = FactoryBot.create(:tournament)
    game = FactoryBot.create(:game)
    team = game.away

    UnassignGamesJob.perform_now(
      tournament_id: tournament.id,
      team_id: team.id
    )

    assert_nil game.reload.away
  end
end
