class Resolvers::UnscheduleGame < Resolvers::BaseResolver
  def call(inputs, ctx)
    game_id = database_id(inputs[:game_id])

    @tournament = ctx[:tournament]
    @game = @tournament.games.find(inputs[:game_id])

    @game.unschedule!

    return {
      success: true,
      message: "Game unscheduled",
      game: @game
    }
  end
end
