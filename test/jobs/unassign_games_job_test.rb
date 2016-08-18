require 'test_helper'

class UnassignGamesJobTest < ActiveJob::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @team = teams(:swift)
    @game = games(:swift_goose)
  end

  test "removes the team from all games (home)" do
    assert_equal @team, @game.home

    UnassignGamesJob.perform_now(
      tournament_id: @tournament.id,
      team_id: @team.id
    )

    assert_nil @game.reload.home
  end

  test "removes the team from all games (away)" do
    team = teams(:goose)
    assert_equal team, @game.away

    UnassignGamesJob.perform_now(
      tournament_id: @tournament.id,
      team_id: team.id
    )

    assert_nil @game.reload.away
  end
end
