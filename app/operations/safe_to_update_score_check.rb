class SafeToUpdateScoreCheck < ApplicationOperation
  input :game, accepts: Game, required: true, type: :keyword
  input :home_score, accepts: Integer, required: true, type: :keyword
  input :away_score, accepts: Integer, required: true, type: :keyword

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

  # actually calculate the dependent pool games?
  # stages will help with this eventually
  def bracket_games_played?
    Game.where(
      tournament_id: game.tournament_id,
      division_id: game.division_id,
      round: 1,
      pool: nil,
      score_confirmed: true
    ).exists?
  end

  def dependent_games_played?
    game.dependent_games.any?{ |g| g.confirmed? }
  end
end
