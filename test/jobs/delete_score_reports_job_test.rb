require 'test_helper'

class UnassignGamesJobTest < ActiveJob::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @team = teams(:swift)
    @report = score_reports(:swift_goose)
  end

  test "deletes all scores submitted by the team" do
    assert_equal @team, @report.team

    DeleteScoreReportsJob.perform_now(
      tournament_id: @tournament.id,
      team_id: @team.id
    )

    assert @report.reload.deleted?
  end
end
