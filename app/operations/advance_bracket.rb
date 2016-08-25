class AdvanceBracket < ApplicationOperation
  processes :game
  property :game, accepts: Game, required: true

  def execute
    advanceWinner
    advanceLoser
  end

  private

  def advanceWinner
    tournament_id = game.tournament_id
    division_id = game.division_id
    bracket_uid = game.bracket_uid

    if next_game = Game.find_by(tournament_id: tournament_id, division_id: division_id, home_prereq: "W#{bracket_uid}")
      next_game.home = game.winner
    elsif next_game = Game.find_by(tournament_id: tournament_id, division_id: division_id, away_prereq: "W#{bracket_uid}")
      next_game.away = game.winner
    end

    return unless next_game

    if next_game.confirmed?
      next_game.reset_score!
      ResetBracketJob.perform_later(game_id: next_game.id)
    end

    next_game.save!
  end

  def advanceLoser
    tournament_id = game.tournament_id
    division_id = game.division_id
    bracket_uid = game.bracket_uid

    if next_game = Game.find_by(tournament_id: tournament_id, division_id: division_id, home_prereq: "L#{bracket_uid}")
      next_game.home = game.loser
    elsif next_game = Game.find_by(tournament_id: tournament_id, division_id: division_id, away_prereq: "L#{bracket_uid}")
      next_game.away = game.loser
    end

    return unless next_game

    if next_game.confirmed?
      next_game.reset_score!
      ResetBracketJob.perform_later(game_id: next_game.id)
    end

    next_game.save!
  end
end