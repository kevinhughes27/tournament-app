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

    UpdateScore.perform(game: @game, home_score: @home_score, away_score: @away_score)

    create_score_entry

    if inputs[:resolve]
      @game.resolve_disputes!
    end

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
end
