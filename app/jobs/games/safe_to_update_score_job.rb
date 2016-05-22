module Games
  class SafeToUpdateScoreJob < ApplicationJob
    queue_as :default

    attr_reader :game, :home_score, :away_score

    def perform(game:, home_score:, away_score:)
      @game, @home_score, @away_score = game, home_score, away_score

      return true if game.unconfirmed?
      return true unless winner_changed?

      if game.pool_game?
        !(pool_finished? && bracket_games_played?)
      else
        !dependent_games_played?
      end
    end

    private

    def winner_changed?
      # `^` is the XOR operator
      (game.home_score > game.away_score) ^ (home_score > away_score)
    end

    def pool_finished?
      Divisions::PoolFinishedJob.perform_now(
        tournament_id: game.tournament_id,
        division_id: game.division_id,
        pool: game.pool
      )
    end

    def bracket_games_played?
      games = Game.where(
        tournament_id: game.tournament_id,
        division_id: game.division_id,
        round: 1
      )
      games.any?{ |g| g.confirmed? }
    end

    def dependent_games_played?
      game.dependent_games.any?{ |g| g.confirmed? }
    end
  end
end
