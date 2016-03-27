module Teams
  class DeleteScoreReportsJob < ActiveJob::Base
    queue_as :default

    def perform(tournament_id:, team_id:)
      reports = ScoreReport.where(tournament_id: tournament_id, team_id: team_id)
      reports.destroy_all
    end
  end
end
