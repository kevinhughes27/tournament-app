class Resolvers::ScheduleGame < Resolver
  attr_reader :game

  delegate :dependent_games,
           :prerequisite_games,
           :pool_game?,
           :bracket_uid,
           :playing_time_range,
           :playing_time_range_string,
           to: :game

  def call(inputs, ctx)
    @tournament = ctx[:tournament]
    @game = load_game(inputs[:game_id])

    game.schedule(inputs[:field_id], inputs[:start_time], inputs[:end_time])

    if game.invalid?
      return {
        success: false,
        game: game,
        userErrors: game.errors.full_messages
      }
    end

    begin
      check_field_conflict(inputs[:field_id])
      check_team_conflict
      check_schedule_conflicts(inputs[:start_time], inputs[:end_time])
    rescue => e
      return {
        success: false,
        game: game,
        userErrors: [e.message]
      }
    end

    game.save

    return {
      success: true,
      game: game
    }
  end

  private

  def load_game(game_id)
    @tournament.games
      .includes(:division, :home, :away)
      .find(game_id)
  end

  def check_field_conflict(field_id)
    games = @tournament.games.where(field_id: field_id, start_time: playing_time_range)
    games = games.where.not(id: game.id)
    if games.present?
      field = @tournament.fields.find(field_id)
      fail "Field #{field.name} is in use at #{playing_time_range_string}"
    end
  end

  def check_team_conflict
    check = TeamConflictCheck.new(game)
    fail check.message if check.perform
  end

  def check_schedule_conflicts(start_time, end_time)
    return if pool_game?

    games = dependent_games.select { |dg| dg.start_time < end_time if dg.start_time }
    fail ordering_error_message(bracket_uid, 'before', games.first.bracket_uid) if games.present?

    games = prerequisite_games.select { |pg| pg.end_time > start_time if pg.start_time }
    fail ordering_error_message(bracket_uid, 'after', games.first.bracket_uid) if games.present?
  end

  def ordering_error_message(uid1, verb, uid2)
    "Game '#{uid1}' must be played #{verb} game '#{uid2}'"
  end
end
