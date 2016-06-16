module Fields
  class UnassignGamesJob < ApplicationJob
    def perform(tournament_id:, field_id:)
      games = Game.where(tournament_id: tournament_id, field_id: field_id)
      games.update_all(field_id: nil, start_time: nil)
    end
  end
end
