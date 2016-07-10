class TeamConflictChecker
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def conflict?
    conflicting_games.present?
  end

  def message
    name = if home_team_is_conflicting?
      conflicting_team_name("home")
    else
      conflicting_team_name("away")
    end

    "Team #{name} is already playing at #{game.playing_time_range_string}"
  end

  private

  def conflicting_team_name(type)
    if conflicting_game.pool_game?
      conflicting_game.send("#{type}_pool_seed")
    else
      conflicting_game.send("#{type}_prereq_uid")
    end
  end

  def home_team_is_conflicting?
    prereq_uids.include? conflicting_game.home_prereq_uid
  end

  def conflicting_game
    @conflicting_game ||= conflicting_games.first
  end

  def conflicting_games
    return unless prereq_uids.present?

    @conflicting_games ||= Game.where(
      tournament: game.tournament,
      division: game.division,
      start_time: game.playing_time_range
    ).where(
      "home_prereq_uid IN (?) OR away_prereq_uid IN (?)", prereq_uids, prereq_uids
    ).where.not(id: game.id)
  end

  def prereq_uids
    [game.home_prereq_uid, game.away_prereq_uid].compact
  end
end
