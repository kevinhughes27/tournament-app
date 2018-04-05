class DivisionCreate < MutationOperation
  input :tournament, accepts: Tournament, type: :keyword, required: true
  input :division_params, type: :keyword, required: true

  attr_reader :division

  def execute
    create_division
    halt unless division.persisted?
    create_games
    create_places
    division
  end

  private

  def create_division
    @division = tournament.divisions.create(division_params)
  end

  def create_games
    games = []

    division.template[:games].each do |t|
      games << Game.from_template(
        tournament_id: tournament.id,
        division_id: division.id,
        template_game: t
      )
    end

    Game.import! games
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

    Place.import! places
  end
end
