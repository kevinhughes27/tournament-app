class DivisionCreate < ApplicationOperation
  input :tournament, accepts: Tournament
  input :division_params

  class Failed < StandardError
    attr_reader :division

    def initialize(division, *args)
      @division = division
      super('DivisionCreate failed.', *args)
    end
  end

  attr_reader :division

  def execute
    @division = tournament.divisions.create(division_params)
    raise Failed(division) unless division.persisted?
    create_games
    create_places
    division
  end

  private

  def create_games
    games = []

    division.template[:games].each do |t|
      games << Game.from_template(
        tournament_id: tournament.id,
        division_id: division.id,
        template_game: t
      )
    end

    Game.import games
  end

  def create_places
    places = []

    division.template[:places].each do |t|
      places << Place.from_template(
        tournament_id: tournament.id,
        division_id: division.id,
        template_place: t
      )
    end

    Place.import places
  end
end
