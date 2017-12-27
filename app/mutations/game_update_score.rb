class GameUpdateScore < ApplicationOperation
  property! :game, accepts: Game
  property! :home_score, accepts: Integer, converts: :to_i
  property! :away_score, accepts: Integer, converts: :to_i

  property :user, accepts: User, default: nil
  property :force, accepts: [true, false], default: false
  property :resolve, accepts: [true, false], default: false

  attr_reader :winner_changed

  def execute
    halt "teams not present" unless game.home && game.away
    halt "ties not allowed for this game" if !ties_allowed? && tie?
    halt "unsafe score update" unless safe_to_update_score?

    game.resolve_disputes! if resolve

    update_score
    create_score_entry if user

    # resets all pool games even if the results haven't changed
    update_pool if game.pool_game?

    advance_bracket if game.bracket_game? && winner_changed

    # pool places are pushed by update_pool
    update_places if game.bracket_game?
  end

  private

  def tie?
    home_score == away_score
  end

  def ties_allowed?
    game.pool_game?
  end

  def safe_to_update_score?
    return true if force

    SafeToUpdateScoreCheck.perform(
      game: game,
      home_score: home_score,
      away_score: away_score
    )
  end

  def update_score
    @winner_changed = winner_changed?
    game.update!(home_score: home_score, away_score: away_score)
  end

  def winner_changed?
    !game.confirmed? || (game.home_score > game.away_score) ^ (home_score > away_score)
  end

  def create_score_entry
    ScoreEntry.create!(
      tournament: game.tournament,
      user: user,
      game: game,
      home: game.home,
      away: game.away,
      home_score: home_score,
      away_score: away_score
    )
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
