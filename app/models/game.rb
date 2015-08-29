class Game < ActiveRecord::Base
  belongs_to :bracket

  belongs_to :field
  belongs_to :tournament
  has_many :score_reports, dependent: :destroy

  belongs_to :home, :class_name => "Team", :foreign_key => :home_id
  belongs_to :away, :class_name => "Team", :foreign_key => :away_id

  validates_presence_of :tournament
  validates_presence_of :bracket, :bracket_uid, :bracket_top, :bracket_bottom

  validates :start_time, date: true, if: Proc.new{ |g| g.start_time.present? }
  validates_presence_of :field,      if: Proc.new{ |g| g.start_time.present? }
  validates_presence_of :start_time, if: Proc.new{ |g| g.field.present? }

  validates_numericality_of :home_score, :away_score, allow_blank: true

  after_save :update_bracket

  scope :assigned, -> { where.not(field_id: nil, start_time: nil) }
  scope :with_teams, -> { where('home_id IS NOT NULL or away_id IS NOT NULL') }

  delegate :division, to: :bracket

  def winner
    home_score > away_score ? home : away
  end

  def loser
    home_score < away_score ? home : away
  end

  def score
    "#{home_score} - #{away_score}"
  end

  def name
    if teams_present?
      "#{home.name} vs #{away.name}"
    else
      "#{bracket.division} #{bracket_uid} (#{bracket_top} vs #{bracket_bottom})"
    end
  end

  def teams_present?
    home.present? && away.present?
  end

  def unassigned?
    field_id.nil? && start_time.blank?
  end

  def confirmed?
    score_confirmed
  end

  def unconfirmed?
    !score_confirmed
  end

  def valid_for_seed_round?
    bracket_top.match(/\A\d+\z/) || bracket_bottom.match(/\A\d+\z/)
  end

  def scores_present?
    home_score.present? && away_score.present?
  end

  def update_score(home_score, away_score)
    if scores_present?
      adjust_score(home_score, away_score)
    else
      set_score(home_score, away_score)
    end
  end

  def dependent_games
    [
      Game.find_by(tournament_id: tournament_id, bracket_id: bracket_id, bracket_top: "w#{bracket_uid}"),
      Game.find_by(tournament_id: tournament_id, bracket_id: bracket_id, bracket_top: "l#{bracket_uid}"),
      Game.find_by(tournament_id: tournament_id, bracket_id: bracket_id, bracket_bottom: "w#{bracket_uid}"),
      Game.find_by(tournament_id: tournament_id, bracket_id: bracket_id, bracket_bottom: "l#{bracket_uid}")
    ].compact
  end

  private

  def set_score(home_score, away_score)
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

  def adjust_score(home_score, away_score)
    winner_changed = (self.home_score > self.away_score) && !(home_score > away_score)
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

  def update_bracket
    return unless self.score_confirmed
    #TODO return if pool game
    advanceWinner
    advanceLoser
  end

  def advanceWinner
    if game = Game.find_by(tournament_id: tournament_id, bracket_id: bracket_id, bracket_top: "w#{bracket_uid}")
      game.home = winner
      game.save!
    elsif game = Game.find_by(tournament_id: tournament_id, bracket_id: bracket_id, bracket_bottom: "w#{bracket_uid}")
      game.away = winner
      game.save
    end
  end

  def advanceLoser
    if game = Game.find_by(tournament_id: tournament_id, bracket_id: bracket_id, bracket_top: "l#{bracket_uid}")
      game.home = loser
      game.save!
    elsif game = Game.find_by(tournament_id: tournament_id, bracket_id: bracket_id, bracket_bottom: "l#{bracket_uid}")
      game.away = loser
      game.save
    end
  end

end
