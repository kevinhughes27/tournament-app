module Divisions
  class ResetBracketJob < ApplicationJob
    queue_as :default

    def perform(game_id:)
      game = Game.find_by(id: game_id)
      game.dependent_games.each do |g|
        g.reset!
        g.home_id = nil
        g.away_id = nil
        g.save!
      end
    end
  end
end
