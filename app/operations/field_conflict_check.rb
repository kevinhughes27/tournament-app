class FieldConflictCheck < ApplicationOperation
  input :game, accepts: Game, required: true

  def execute
    conflicting_games.present?
  end

  def message
    "Field #{game.field.name} is in use at #{game.playing_time_range_string}"
  end

  private

  def conflicting_games
    @conflicting_games ||= start_time_overlaps.or(end_time_overlaps)
  end

  def start_time_overlaps
    Game.where(
      tournament: game.tournament,
      field: game.field,
      start_time: (game.start_time)..(game.end_time - 1.minutes)
    ).where.not(id: game.id)
  end

  def end_time_overlaps
    Game.where(
      tournament: game.tournament,
      field: game.field,
      end_time: (game.start_time + 1.minutes)..(game.end_time)
    ).where.not(id: game.id)
  end
end
