class ResetBracketJob < ApplicationJob
  def perform(game_id:)
    game = Game.find_by(id: game_id)
    game.dependent_games.each do |g|
      g.home_id = nil
      g.away_id = nil

      if g.confirmed?
        g.reset_score!
        ResetBracketJob.perform_later(game_id: g.id)
      end

      g.save!
    end
  end
end
