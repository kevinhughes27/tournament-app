module Divisions
  class PoolFinishedJob < ApplicationJob
    def perform(tournament_id:, division_id:, pool:)
      games = Game.where(tournament_id: tournament_id, division_id: division.id, pool: pool)
      games.all? { |game| game.confirmed? }
    end
  end
end
