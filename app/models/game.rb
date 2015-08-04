class Game < ActiveRecord::Base
  belongs_to :bracket

  belongs_to :field
  belongs_to :tournament

  belongs_to :home, :class_name => "Team", :foreign_key => :home_id
  belongs_to :away, :class_name => "Team", :foreign_key => :away_id

  after_save :update_bracket

  def winner
    home_score > away_score ? home : away
  end

  def loser
    home_score < away_score ? home : away
  end

  def name
    "#{home.name} vs #{away.name}"
  end

  def confirmed?
    score_confirmed
  end

  def unconfirmed?
    !score_confirmed
  end

  def valid_for_seed_round?
    bracket_top.match(/\A\d+\z/) && bracket_bottom.match(/\A\d+\z/)
  end

  def confirm_score(home_score, away_score)
    update_attributes!(
      home_score: home_score,
      away_score: away_score,
      score_confirmed: true
    )

    home.points_for += home_score
    away.points_for += away_score

    if home_score > away_score
      home.wins += 1
    else
      away.wins += 1
    end

    home.save!
    away.save!
  end

  def update_score(home_score, away_score)
    winner_changed = (self.home_score > self.away_score) && (home_score > away_score)
    home_delta = home_score - self.home_score
    away_delta = away_score - self.away_score

    update_attributes!(
      home_score: home_score,
      away_score: away_score,
      score_confirmed: true
    )

    home.points_for += home_delta
    away.points_for += away_delta

    if winner_changed && home_score > away_score
      away.wins -= 1
      home.wins += 1
    elsif winner_changed
      home.wins -= 1
      away.wins += 1
    end

    home.save!
    away.save!
  end

  private

  def update_bracket
    return unless self.score_confirmed
    advanceWinner
    advanceLose
  end

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
