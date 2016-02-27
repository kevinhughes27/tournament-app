module Divisions
  class CreateGamesJob < ActiveJob::Base
    queue_as :default

    def perform(tournament_id:, division_id:, template:)
      template[:games].each do |game|
        Game.create!(
          division_id: division_id,
          tournament_id: tournament_id,
          round: game[:round],
          bracket_uid: game[:uid],
          home_prereq_uid: game[:home],
          away_prereq_uid: game[:away]
        )
      end
    end
  end
end
