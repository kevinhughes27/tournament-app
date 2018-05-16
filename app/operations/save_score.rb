class SaveScore < ApplicationOperation
  input :game, accepts: Game, type: :keyword, required: true
  input :home_score, accepts: Integer, type: :keyword, required: true
  input :away_score, accepts: Integer, type: :keyword, required: true

  def execute
    winner_changed = update_score

    # resets all pool games even if the results haven't changed
    update_pool if game.pool_game?

    advance_bracket if game.bracket_game? && winner_changed

    # pool places are pushed by update_pool
    update_places if game.bracket_game?
  end

  private

  def update_score
    winner_changed = winner_changed?
    game.update!(home_score: home_score, away_score: away_score)
    winner_changed
  end

  def winner_changed?
    !game.confirmed? || (game.home_score > game.away_score) ^ (home_score > away_score)
  end

  def update_pool
    FinishPoolJob.perform_later(division: game.division, pool_uid: game.pool)
  end

  def advance_bracket
    AdvanceBracketJob.perform_later(game_id: game.id)
  end

  def update_places
    UpdatePlacesJob.perform_later(game_id: game.id)
  end
end
