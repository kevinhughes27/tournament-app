module Games
  class UpdateScoreJob < ApplicationJob
    queue_as :default

    attr_reader :game, :home_score, :away_score

    def perform(game:, home_score:, away_score:, force: false)
      @game, @home_score, @away_score = game, home_score, away_score

      return unless game.teams_present?
      return unless safe_to_update_score? || force

      update_score

      update_pool if game.pool_game?
      update_bracket if game.bracket_game?

      # pool places are pushed by update_pool
      update_places if game.bracket_game?

      true
    end

    private

    def safe_to_update_score?
      Games::SafeToUpdateScoreJob.perform_now(
        game: game,
        home_score: home_score,
        away_score: away_score
      )
    end

    def update_score
      if game.scores_present?
        adjust_score
      else
        set_score
      end
    end

    def set_score
      Games::SetScoreJob.perform_now(
        game: game,
        home_score: home_score,
        away_score: away_score
      )
    end

    def adjust_score
      Games::AdjustScoreJob.perform_now(
        game: game,
        home_score: home_score,
        away_score: away_score
      )
    end

    def update_pool
      Divisions::UpdatePoolJob.perform_later(
        division: game.division,
        pool: game.pool
      )
    end

    def update_bracket
      Divisions::UpdateBracketJob.perform_later(game_id: game.id)
    end

    def update_places
      Divisions::UpdatePlacesJob.perform_later(game_id: game.id)
    end
  end
end
