module Divisions
  class CreateGamesJob < ApplicationJob
    def perform(tournament_id:, division_id:, template:)
      template[:games].each do |template_game|
        Game::create_from_template!(
          tournament_id: tournament_id,
          division_id: division_id,
          template_game: template_game
        )
      end
    end
  end
end
