class ScheduleConflictCheck < ApplicationOperation
  input :game, accepts: Game, required: true

  def execute
    return if game.pool_game?
    games_out_of_order?
  end

  def message
    if dependent_games_out_of_order.present?
      g = dependent_games_out_of_order.first
      ordering_error_message(game.bracket_uid, 'before', g.bracket_uid)
    elsif prerequisite_games_out_of_order.present?
      g = prerequisite_games_out_of_order.first
      ordering_error_message(game.bracket_uid, 'after', g.bracket_uid)
    end
  end

  private

  def games_out_of_order?
    dependent_games_out_of_order.present? || prerequisite_games_out_of_order.present?
  end

  def dependent_games_out_of_order
    @dependent_games_out_of_order ||= game.dependent_games.select do |dg|
      dg.start_time < game.end_time if dg.start_time
    end
  end

  def prerequisite_games_out_of_order
    @prerequisite_games_out_of_order ||= game.prerequisite_games.select do |pg|
      pg.end_time > game.start_time if pg.start_time
    end
  end

  def ordering_error_message(uid1, verb, uid2)
    "Game '#{uid1}' must be played #{verb} game '#{uid2}'"
  end
end
