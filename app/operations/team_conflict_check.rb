class TeamConflictCheck < ComposableOperations::Operation
  proccesses :game
  property :game, accepts: Game, required: true

  def execute
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
      conflicting_game.send("#{type}_prereq")
    end
  end

  def home_team_is_conflicting?
    prereqs.include? conflicting_game.home_prereq
  end

  def conflicting_game
    @conflicting_game ||= conflicting_games.first
  end

  def conflicting_games
    return unless prereqs.present?

    @conflicting_games ||= Game.where(
      tournament: game.tournament,
      division: game.division,
      start_time: game.playing_time_range
    ).where(
      "home_prereq IN (?) OR away_prereq IN (?)", prereqs, prereqs
    ).where.not(id: game.id)
  end

  def prereqs
    [game.home_prereq, game.away_prereq].compact
  end
end
