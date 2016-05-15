module Games
  class UpdateScoreJob < ApplicationJob
    queue_as :default

    attr_reader :game

    def perform(game:, home_score:, away_score:, force: false)
      @game = game
      return unless game.teams_present?
      return unless safe_to_update_score?(home_score, away_score) || force

      if game.scores_present?
        adjust_score(home_score, away_score)
      else
        set_score(home_score, away_score)
      end
    end

    private

    def safe_to_update_score?(home_score, away_score)
      return true if game.unconfirmed?

      # `^` is the XOR operator
      winner_changed = (game.home_score > game.away_score) ^ (home_score > away_score)
      return true unless winner_changed

      if game.pool_game?
        !pool_finished?
      else
        game.dependent_games.all?{ |g| g.unconfirmed? }
      end
    end

    def pool_finished?
      Divisions::PoolFinishedJob.perform_now(
        tournament_id: game.tournament_id,
        division_id: game.division_id,
        pool: game.pool
      )
    end

    def set_score(home_score, away_score)
      Games::SetScoreJob.perform_now(
        game: game,
        home_score: home_score,
        away_score: away_score
      )
    end

    def adjust_score(home_score, away_score)
      Games::AdjustScoreJob.perform_now(
        game: game,
        home_score: home_score,
        away_score: away_score
      )
    end
  end
end
