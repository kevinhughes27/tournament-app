class UpdatePlacesJob < ApplicationJob
  def perform(game_id:)
    game = Game.find_by(id: game_id)
    UpdatePlaces.perform(game)
  end
end
