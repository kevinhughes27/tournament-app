module Divisions
  class CreateGamesJob < ApplicationJob
    queue_as :default

    def perform(tournament_id:, division_id:, template:)
      template[:games].each do |game|
        Game.create!(
          tournament_id: tournament_id,
          division_id: division_id,
          pool: game[:pool],
          round: game[:round],
          bracket_uid: game[:uid],
          home_prereq_uid: game[:home],
          away_prereq_uid: game[:away]
        )
      end
    end
  end
end
