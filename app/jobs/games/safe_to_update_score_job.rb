module Games
  class SafeToUpdateScoreJob < ApplicationJob
    attr_reader :game, :home_score, :away_score

    def perform(game:, home_score:, away_score:)
      @game, @home_score, @away_score = game, home_score, away_score

      return true if game.unconfirmed?
      if game.pool_game?
        !(pool_finished? && bracket_games_played?)
      elsif game.bracket_game?
        !winner_changed? || !dependent_games_played?
      end
    end

    private

    def winner_changed?
      (game.home_score > game.away_score) ^ (home_score > away_score)
    end

    def pool_finished?
      Division::pool_finished?(
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
