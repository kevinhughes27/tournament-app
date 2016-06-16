module Teams
  class DeleteScoreReportsJob < ApplicationJob
    def perform(tournament_id:, team_id:)
      reports = ScoreReport.where(tournament_id: tournament_id, team_id: team_id)
      reports.destroy_all
    end
  end
end
