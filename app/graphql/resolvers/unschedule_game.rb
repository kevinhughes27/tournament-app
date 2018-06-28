class Resolvers::UscheduleGame < Resolvers::BaseResolver
  def call(inputs, ctx)
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
