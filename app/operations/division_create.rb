class DivisionCreate < ApplicationOperation
  processes :tournament, :division_params
  property :tournament, accepts: Tournament

  attr_reader :division

  def execute
    @division = tournament.divisions.create(division_params)
    fail unless division.persisted?
    create_games
    create_places
  end

  private

  def create_games
    CreateGamesJob.perform_now(
      tournament_id: tournament.id,
      division_id: division.id,
      template: division.template
    )
  end

  def create_places
    CreatePlacesJob.perform_later(
      tournament_id: tournament.id,
      division_id: division.id,
      template: division.template
    )
  end
end
