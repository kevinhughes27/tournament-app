class SetGameScore < ComposableOperations::Operation
  property :game, accepts: Game, required: true
  property :home_score, accepts: Integer, required: true
  property :away_score, accepts: Integer, required: true

  def execute
    ActiveRecord::Base.transaction do
      game.update!(
        home_score: home_score,
        away_score: away_score
      )

      game.home.points_for += home_score
      game.away.points_for += away_score

      if home_score > away_score
        game.home.wins += 1
      else
        game.away.wins += 1
      end

      game.home.save!
      game.away.save!
    end
  end
end
