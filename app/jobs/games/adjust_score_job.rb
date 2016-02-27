module Games
  class AdjustScoreJob < ActiveJob::Base
    queue_as :default

    def perform(game:, home_score:, away_score:)
      winner_changed = (game.home_score > game.away_score) && !(home_score > away_score)
      home_delta = home_score - game.home_score
      away_delta = away_score - game.away_score

      ActiveRecord::Base.transaction do
        game.update_attributes!(
          home_score: home_score,
          away_score: away_score,
          score_confirmed: true
        )

        game.home.points_for += home_delta
        game.away.points_for += away_delta

        if winner_changed && home_score > away_score
          game.away.wins -= 1
          game.home.wins += 1
        elsif winner_changed
          game.home.wins -= 1
          game.away.wins += 1
        end

        game.home.save!
        game.away.save!
      end
    end
  end
end
