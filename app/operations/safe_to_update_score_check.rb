class SafeToUpdateScoreCheck < ApplicationOperation
  property! :game, accepts: Game
  property! :home_score, accepts: Integer
  property! :away_score, accepts: Integer

  def execute
    return true if game.unconfirmed?

    unsafe = if game.pool_game?
      safe_for_pool_game?
    elsif game.bracket_game?
      safe_for_bracket_game?
    end

    !unsafe
  end

  private

  def safe_for_pool_game?
    pool = Pool.new(game.division, game.pool)

    pool.finished? &&
    pool.results_changed?(game, home_score, away_score) &&
    bracket_games_played?
  end

  def safe_for_bracket_game?
    winner_changed? && dependent_games_played?
  end

  def winner_changed?
    (game.home_score > game.away_score) ^ (home_score > away_score)
  end

  def bracket_games_played?
    games = Game.where(
      tournament_id: game.tournament_id,
      division_id: game.division_id,
      round: 1,
      pool: nil
    )
    games.any?{ |g| g.confirmed? }
  end

  def dependent_games_played?
    game.dependent_games.any?{ |g| g.confirmed? }
  end
end
