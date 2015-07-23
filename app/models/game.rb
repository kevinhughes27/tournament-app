class Game < ActiveRecord::Base
  include UpdateSet
  belongs_to :field
  belongs_to :tournament
  belongs_to :home, :class_name => "Team", :foreign_key => :home_id
  belongs_to :away, :class_name => "Team", :foreign_key => :away_id

  before_create :ensure_game_type

  def ensure_game_type
    unless self.type
      self.type = 'PoolGame'
      self.type = 'ByeGame' if home_id.nil? && away_id.nil?
    end
  end

  def winner
    home_score > away_score ? home : away
  end

  def loser
    home_score < away_score ? home : away
  end


  # ToDo update after I add name column
  def game_name
    "#{home.name} vs #{away.name}"
  end

  def unconfirmed?
    !score_confirmed
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

end
