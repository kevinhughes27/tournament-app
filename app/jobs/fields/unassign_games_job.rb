module Fields
  class UnassignGamesJob < ActiveJob::Base
    queue_as :default

    def perform(tournament_id:, field_id:)
      games = Game.where(tournament_id: tournament_id, field_id: field_id)
      games.update_all(field_id: nil)
    end
  end
end
