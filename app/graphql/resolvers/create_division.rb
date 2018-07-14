class Resolvers::CreateDivision < Resolvers::BaseResolver
  def call(inputs, ctx)
    @tournament = ctx[:tournament]
    @division = @tournament.divisions.create(inputs.to_h)

    if @division.persisted?
      create_games
      create_places
      {
        success: true,
        division: @division
      }
    else
       {
         success: false,
         division: @division,
         user_errors: @division.fields_errors
       }
    end
  end

  private

  def create_games
    games = []

    @division.template[:games].each do |t|
      games << Game.from_template(
        tournament_id: @tournament.id,
        division_id: @division.id,
        template_game: t
      )
    end

    Game.import! games
  end

  def create_places
    places = []

    @division.template[:places].each do |t|
      places << Place.from_template(
        tournament_id: @tournament.id,
        division_id: @division.id,
        template_place: t
      )
    end

    Place.import! places
  end
end
