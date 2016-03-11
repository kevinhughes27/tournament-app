module Teams
  class UnassignGamesJob < ActiveJob::Base
    queue_as :default

    def perform(tournament_id:, team_id:)
      games = Game.where(tournament_id: tournament_id, home_id: team_id)
      games.update_all(home_id: nil)

      games = Game.where(tournament_id: tournament_id, away_id: team_id)
      games.update_all(away_id: nil)
    end
  end
end
