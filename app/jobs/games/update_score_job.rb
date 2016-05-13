module Games
  class UpdateScoreJob < ApplicationJob
    queue_as :default

    def perform(game:, home_score:, away_score:, force: false)
      return unless game.teams_present?
      return unless safe_to_update_score?(game, home_score, away_score) || force

      if game.scores_present?
        adjust_score(game, home_score, away_score)
      else
        set_score(game, home_score, away_score)
      end
    end

    private

    def safe_to_update_score?(game, home_score, away_score)
      return true if game.unconfirmed?

      winner_changed = (game.home_score > game.away_score) && !(home_score > away_score)
      return true unless winner_changed

      if game.pool_game?
        !game.pool_finished?
      else
        game.dependent_games.all?{ |g| g.unconfirmed? }
      end
    end

    def set_score(game, home_score, away_score)
      Games::SetScoreJob.perform_now(
        game: game,
        home_score: home_score,
        away_score: away_score
      )
    end

    def adjust_score(game, home_score, away_score)
      Games::AdjustScoreJob.perform_now(
        game: game,
        home_score: home_score,
        away_score: away_score
      )
    end
  end
end
