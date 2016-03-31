module Divisions
  class UpdatePlacesJob < ActiveJob::Base
    queue_as :default

    def perform(game_id:)
      game = Game.find_by(id: game_id)
      winnerPlace(game)
      loserPlace(game)
    end

    private

    def winnerPlace(game)
      tournament_id = game.tournament_id
      division_id = game.division_id
      bracket_uid = game.bracket_uid

      if place = Place.find_by(tournament_id: tournament_id, division_id: division_id, prereq_uid: "W#{bracket_uid}")
        place.team = game.winner
        place.save!
      end
    end

    def loserPlace(game)
      tournament_id = game.tournament_id
      division_id = game.division_id
      bracket_uid = game.bracket_uid

      if place = Place.find_by(tournament_id: tournament_id, division_id: division_id, prereq_uid: "L#{bracket_uid}")
        place.team = game.loser
        place.save!
      end
    end
  end
end
