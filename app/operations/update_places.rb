class UpdatePlaces < ApplicationOperation
  input :game
  property! :game, accepts: Game

  def execute
    pushWinnerPlace
    pushLoserPlace
  end

  private

  def pushWinnerPlace
    bracket_uid = game.bracket_uid

    if place = find_place("W#{bracket_uid}")
      place.team = game.winner
      place.save!
    end
  end

  def pushLoserPlace
    bracket_uid = game.bracket_uid

    if place = find_place("L#{bracket_uid}")
      place.team = game.loser
      place.save!
    end
  end

  def find_place(prereq)
    tournament_id = game.tournament_id
    division_id = game.division_id

    Place.find_by(
      tournament_id: tournament_id,
      division_id: division_id,
      prereq: prereq
    )
  end
end
