module Divisions
  class UpdatePlacesJob < ApplicationJob
    attr_reader :game

    def perform(game_id:)
      @game = Game.find_by(id: game_id)
      pushWinnerPlace(game)
      pushLoserPlace(game)
    end

    private

    def pushWinnerPlace(game)
      bracket_uid = game.bracket_uid

      if place = find_place("W#{bracket_uid}")
        place.team = game.winner
        place.save!
      end
    end

    def pushLoserPlace(game)
      bracket_uid = game.bracket_uid

      if place = find_place("L#{bracket_uid}")
        place.team = game.loser
        place.save!
      end
    end

    def find_place(prereq_uid)
      tournament_id = game.tournament_id
      division_id = game.division_id

      Place.find_by(
        tournament_id: tournament_id,
        division_id: division_id,
        prereq_uid: prereq_uid
      )
    end
  end
end
