class BracketGame < Game
  after_save :update_bracket

  class BracketGameNotFound < StandardError; end

  def update_bracket
    return unless self.score_confirmed
    advanceWinner
    advanceLose
  end

  private

  def advanceWinner
    if game = BracketGame.find_by(tournament_id: tournament_id, division: division, bracket_top: "w#{bracket_code}")
      game.home = winner
      game.save!
    elsif game = BracketGame.find_by(tournament_id: tournament_id, division: division, bracket_bottom: "w#{bracket_code}")
      game.away = winner
      game.save
    else
      raise BracketGameNotFound
    end
  end

  def advanceLose
    if game = BracketGame.find_by(tournament_id: tournament_id, division: division, bracket_top: "l#{bracket_code}") ||
      game.home = loser
      game.save!
    elsif game = BracketGame.find_by(tournament_id: tournament_id, division: division, bracket_bottom: "l#{bracket_code}")
      game.away = loser
      game.save
    else
      raise BracketGameNotFound
    end
  end

end
