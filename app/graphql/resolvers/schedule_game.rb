class Resolvers::ScheduleGame < Resolvers::BaseResolver
  def call(inputs, ctx)
    @tournament = ctx[:tournament]
    @game = load_game(inputs[:game_id])

    @game.schedule(inputs[:field_id], inputs[:start_time], inputs[:end_time])

    if @game.invalid?
      return {
        success: false,
        game: @game,
        user_errors: @game.fields_errors
      }
    end

    begin
      check_field_conflict
      check_team_conflict
      check_schedule_conflicts
    rescue => e
      return {
        success: false,
        game: @game,
        message: e.message
      }
    end

    @game.save

    return {
      success: true,
      game: @game
    }
  end

  private

  def load_game(game_id)
    @tournament.games
      .includes(:division, :home, :away)
      .find(game_id)
  end

  def check_field_conflict
    check = FieldConflictCheck.new(@game)
    fail check.message if check.perform
  end

  def check_team_conflict
    check = TeamConflictCheck.new(@game)
    fail check.message if check.perform
  end

  def check_schedule_conflicts
    check = ScheduleConflictCheck.new(@game)
    fail check.message if check.perform
  end
end
