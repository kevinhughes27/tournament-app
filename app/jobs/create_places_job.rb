class CreatePlacesJob < ApplicationJob
  def perform(tournament_id:, division_id:, template:)
    template[:places].each do |template_place|
      Place.create_from_template!(
        tournament_id: tournament_id,
        division_id: division_id,
        template_place: template_place
      )
    end
  end
end
