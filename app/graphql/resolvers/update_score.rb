class Resolvers::UpdateScore < Resolvers::BaseResolver
  CONFIRM_MSG = """This update will change the teams in games that come after it\
 and some of those games have been scored. If you update this\
 score those games will be reset. This cannot be undone."""

  def call(inputs, ctx)
    @tournament = ctx[:tournament]
    @user = ctx[:current_user]
    @game = @tournament.games.find(inputs[:game_id])

    @home_score = inputs[:home_score]
    @away_score = inputs[:away_score]

    if !(@game.home && @game.away)
      return {
        game: @game,
        success: false,
        message: "teams not present"
      }
    end

    if (!ties_allowed? && tie?)
      return {
        game: @game,
        success: false,
        message: "ties not allowed for this game"
      }
    end

    if (!inputs[:confirm] && !safe_to_update_score?)
      return {
        game: @game,
        success: false,
        confirm: true,
        message: CONFIRM_MSG
      }
    end

    SaveScore.perform(game: @game, home_score: @home_score, away_score: @away_score)

    create_score_entry

    if inputs[:resolve]
      @game.resolve_disputes!
    end

    return {
      game: @game,
      success: true,
      message: 'Score updated'
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
