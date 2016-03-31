module Divisions
  class CreatePlacesJob < ActiveJob::Base
    queue_as :default

    def perform(tournament_id:, division_id:, template:)
      template[:places].each do |place|
        Place.create!(
          tournament_id: tournament_id,
          division_id: division_id,
          position: place[:position],
          prereq_uid: place[:prereq_uid]
        )
      end
    end
  end
end
