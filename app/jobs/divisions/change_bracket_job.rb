module Divisions
  class ChangeBracketJob < ApplicationJob

    def perform(tournament_id:, division_id:, new_template:)
      Game.where(
        tournament_id: tournament_id,
        division_id: division_id
      ).destroy_all

      Place.where(
        tournament_id: tournament_id,
        division_id: division_id
      ).destroy_all

      Divisions::CreateGamesJob.perform_now(
        tournament_id: tournament_id,
        division_id: division_id,
        template: new_template
      )

      Divisions::CreatePlacesJob.perform_now(
        tournament_id: tournament_id,
        division_id: division_id,
        template: new_template
      )
    end
  end
end
