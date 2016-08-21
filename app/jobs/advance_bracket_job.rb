class AdvanceBracketJob < ApplicationJob
  def perform(game_id:)
    game = Game.find_by(id: game_id)
    AdvanceBracket.perform(game)
  end
end
