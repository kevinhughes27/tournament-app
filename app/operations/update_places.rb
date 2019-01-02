class UpdatePlaces < ApplicationOperation
  input :game, accepts: Game, required: true

  def execute
    push_winner
    push_loser
  end

  private

  def push_winner
    if place = winner_place
      place.team = game.winner
      place.save!
    end
  end

  def push_loser
    if place = loser_place
      place.team = game.loser
      place.save!
    end
  end

  private

  def winner_place
    places.find { |p| p.prereq == "W#{game.bracket_uid}"}
  end

  def loser_place
    places.find { |p| p.prereq == "L#{game.bracket_uid}"}
  end

  def places
    @places ||= load_places
  end

  def load_places
    tournament_id = game.tournament_id
    division_id = game.division_id
    bracket_uid = game.bracket_uid

    Place.where(
      tournament_id: tournament_id,
      division_id: division_id,
      prereq: ["W#{bracket_uid}", "L#{bracket_uid}"]
    )
  end
end
