class AdvanceBracket < ApplicationOperation
  input :game
  property! :game, accepts: Game

  def execute
    advanceWinner
    advanceLoser
  end

  private

  def advanceWinner
    tournament_id = game.tournament_id
    division_id = game.division_id
    bracket_uid = game.bracket_uid

    dependent_home_games = Game.where(tournament_id: tournament_id, division_id: division_id, home_prereq: "W#{bracket_uid}")
    if dependent_home_games.present?
      dependent_home_games.update_all(home_id: game.winner.id)
    end

    dependent_away_games = Game.where(tournament_id: tournament_id, division_id: division_id, away_prereq: "W#{bracket_uid}")
    if dependent_away_games.present?
      dependent_away_games.update_all(away_id: game.winner.id)
    end

    dependent_games = dependent_home_games + dependent_away_games
    return unless dependent_games.present?

    dependent_games.each do |next_game|
      if next_game.confirmed?
        next_game.reset_score!
        ResetBracketJob.perform_later(game_id: next_game.id)
      end
      next_game.save!
    end
  end

  def advanceLoser
    tournament_id = game.tournament_id
    division_id = game.division_id
    bracket_uid = game.bracket_uid

    dependent_home_games = Game.where(tournament_id: tournament_id, division_id: division_id, home_prereq: "L#{bracket_uid}")
    if dependent_home_games.present?
      dependent_home_games.update_all(home_id: game.loser.id)
    end

    dependent_away_games = Game.where(tournament_id: tournament_id, division_id: division_id, away_prereq: "L#{bracket_uid}")
    if dependent_away_games.present?
      dependent_away_games.update_all(away_id: game.loser.id)
    end

    dependent_games = dependent_home_games + dependent_away_games
    return unless dependent_games.present?

    dependent_games.each do |next_game|
      if next_game.confirmed?
        next_game.reset_score!
        ResetBracketJob.perform_later(game_id: next_game.id)
      end
      next_game.save!
    end
  end
end
