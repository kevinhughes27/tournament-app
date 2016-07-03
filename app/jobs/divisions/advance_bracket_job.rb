module Divisions
  class AdvanceBracketJob < ApplicationJob

    def perform(game_id:)
      game = Game.find_by(id: game_id)
      advanceWinner(game)
      advanceLoser(game)
    end

    private

    def advanceWinner(game)
      tournament_id = game.tournament_id
      division_id = game.division_id
      bracket_uid = game.bracket_uid

      if next_game = Game.find_by(tournament_id: tournament_id, division_id: division_id, home_prereq_uid: "W#{bracket_uid}")
        next_game.home = game.winner
      elsif next_game = Game.find_by(tournament_id: tournament_id, division_id: division_id, away_prereq_uid: "W#{bracket_uid}")
        next_game.away = game.winner
      end

      return unless next_game

      if next_game.confirmed?
        next_game.reset_score!
        Divisions::ResetBracketJob.perform_later(game_id: next_game.id)
      end

      next_game.save!
    end

    def advanceLoser(game)
      tournament_id = game.tournament_id
      division_id = game.division_id
      bracket_uid = game.bracket_uid

      if next_game = Game.find_by(tournament_id: tournament_id, division_id: division_id, home_prereq_uid: "L#{bracket_uid}")
        next_game.home = game.loser
      elsif next_game = Game.find_by(tournament_id: tournament_id, division_id: division_id, away_prereq_uid: "L#{bracket_uid}")
        next_game.away = game.loser
      end

      return unless next_game

      if next_game.confirmed?
        next_game.reset_score!
        Divisions::ResetBracketJob.perform_later(game_id: next_game.id)
      end

      next_game.save!
    end
  end
end
