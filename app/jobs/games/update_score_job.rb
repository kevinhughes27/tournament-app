module Games
  class UpdateScoreJob < ApplicationJob
    queue_as :default

    attr_reader :game, :home_score, :away_score, :winner_changed

    def perform(game:, home_score:, away_score:, force: false)
      @game, @home_score, @away_score = game, home_score, away_score

      return unless game.teams_present?
      return unless force || safe_to_update_score?

      update_score

      # resets all pool games even if the results haven't changed
      update_pool if game.pool_game?

      update_bracket if game.bracket_game? && winner_changed

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
      @winner_changed = !game.scores_present? ||
                        (game.home_score > game.away_score) ^ (home_score > away_score)

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
      Divisions::FinishPoolJob.perform_later(
        division: game.division,
        pool: game.pool
      )
    end

    def update_bracket
      Divisions::AdvanceBracketJob.perform_later(game_id: game.id)
    end

    def update_places
      Divisions::UpdatePlacesJob.perform_later(game_id: game.id)
    end
  end
end
