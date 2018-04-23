class Resolvers::GameUpdateScore < Resolver
  def call(inputs, ctx)
    @tournament = ctx[:tournament]
    @user = ctx[:current_user]
    @game = @tournament.games.find(inputs[:game_id])

    @home_score = inputs[:home_score]
    @away_score = inputs[:away_score]

    if !(@game.home && @game.away)
      return {
        success: false,
        errors: ["teams not present"]
      }
    end

    if (!ties_allowed? && tie?)
      return {
        success: false,
        errors: ["ties not allowed for this game"]
      }
    end

    if (!inputs[:force] && !safe_to_update_score?)
      return {
        success: false,
        errors: ["unsafe score update"]
      }
    end

    @game.resolve_disputes! if inputs[:resolve]

    update_score
    create_score_entry if @user

    # resets all pool games even if the results haven't changed
    update_pool if @game.pool_game?

    advance_bracket if @game.bracket_game? && @winner_changed

    # pool places are pushed by update_pool
    update_places if @game.bracket_game?

    return {
      success: true
    }
  end

  private

  def tie?
    @home_score == @away_score
  end

  def ties_allowed?
    @game.pool_game?
  end

  def safe_to_update_score?
    SafeToUpdateScoreCheck.perform(
      game: @game,
      home_score: @home_score,
      away_score: @away_score
    )
  end

  def update_score
    @winner_changed = winner_changed?
    @game.update!(home_score: @home_score, away_score: @away_score)
  end

  def winner_changed?
    !@game.confirmed? || (@game.home_score > @game.away_score) ^ (@home_score > @away_score)
  end

  def create_score_entry
    ScoreEntry.create!(
      tournament: @game.tournament,
      user: @user,
      game: @game,
      home: @game.home,
      away: @game.away,
      home_score: @home_score,
      away_score: @away_score
    )
  end

  def update_pool
    FinishPoolJob.perform_later(division: @game.division, pool_uid: @game.pool)
  end

  def advance_bracket
    AdvanceBracketJob.perform_later(game_id: @game.id)
  end

  def update_places
    UpdatePlacesJob.perform_later(game_id: @game.id)
  end
end
