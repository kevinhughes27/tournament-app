module Divisions
  class UpdateBracketJob < ActiveJob::Base
    queue_as :default

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
        next_game.save!
      elsif next_game = Game.find_by(tournament_id: tournament_id, division_id: division_id, away_prereq_uid: "W#{bracket_uid}")
        next_game.away = game.winner
        next_game.save
      end
    end

    def advanceLoser(game)
      tournament_id = game.tournament_id
      division_id = game.division_id
      bracket_uid = game.bracket_uid

      if next_game = Game.find_by(tournament_id: tournament_id, division_id: division_id, home_prereq_uid: "L#{bracket_uid}")
        next_game.home = game.loser
        next_game.save!
      elsif next_game = Game.find_by(tournament_id: tournament_id, division_id: division_id, away_prereq_uid: "L#{bracket_uid}")
        next_game.away = game.loser
        next_game.save
      end
    end
  end
end
