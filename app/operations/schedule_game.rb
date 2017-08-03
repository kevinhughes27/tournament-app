class ScheduleGame < ApplicationOperation
  input :game, accepts: Game, required: true
  input :field_id, converts: :to_i, required: true
  input :start_time, converts: :to_datetime, required: true
  input :end_time, converts: :to_datetime, required: true

  delegate :tournament,
           :dependent_games,
           :prerequisite_games,
           :pool_game?,
           :bracket_uid,
           :playing_time_range,
           :playing_time_range_string,
           to: :game

  def execute
    game.schedule(field_id, start_time, end_time)
    fail game.errors.full_messages.to_sentence if game.invalid?

    check_field_conflict
    check_team_conflict
    check_schedule_conflicts

    game.save
  end

  private

  def check_field_conflict
    games = tournament.games.where(field_id: field_id, start_time: playing_time_range)
    games = games.where.not(id: game.id)
    if games.present?
      field = tournament.fields.find(field_id)
      fail "Field #{field.name} is in use at #{playing_time_range_string}"
    end
  end

  def check_team_conflict
    check = TeamConflictCheck.perform(game)
    fail check if check
  end

  def check_schedule_conflicts
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
