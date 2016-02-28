class Game < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :division
  belongs_to :field

  belongs_to :home, :class_name => "Team", :foreign_key => :home_id
  belongs_to :away, :class_name => "Team", :foreign_key => :away_id

  has_many :score_reports, dependent: :destroy

  validates_presence_of :tournament
  validates_presence_of :division, :home_prereq_uid, :away_prereq_uid

  validates_presence_of :pool, if: Proc.new{ |g| g.bracket_uid.nil? }
  validates_presence_of :bracket_uid, if: Proc.new{ |g| g.pool.nil? }

  validates :start_time, date: true, if: Proc.new{ |g| g.start_time.present? }
  validates_presence_of :field,      if: Proc.new{ |g| g.start_time.present? }
  validates_presence_of :start_time, if: Proc.new{ |g| g.field.present? }

  validates_numericality_of :home_score, :away_score, allow_blank: true

  after_save :update_bracket

  scope :assigned, -> { where.not(field_id: nil, start_time: nil) }
  scope :with_teams, -> { where('home_id IS NOT NULL or away_id IS NOT NULL') }

  def winner
    home_score > away_score ? home : away
  end

  def loser
    home_score < away_score ? home : away
  end

  def score
    return unless scores_present?
    "#{home_score} - #{away_score}"
  end

  def home_name
    home.present? ? home.name : ""
  end

  def away_name
    away.present? ? away.name : ""
  end

  def name
    if teams_present?
      "#{home.name} vs #{away.name}"
    else
      "#{division.name} #{bracket_uid} (#{home_prereq_uid} vs #{away_prereq_uid})"
    end
  end

  def teams_present?
    home.present? && away.present?
  end

  def unassigned?
    field_id.nil? && start_time.blank?
  end

  def played?
    return unless start_time
    Time.now > end_time
  end

  def end_time
    start_time + tournament.time_cap.minutes
  end

  def confirmed?
    score_confirmed
  end

  def valid_for_seed_round?
    home_prereq_uid.match(/\A\d+\z/) || away_prereq_uid.match(/\A\d+\z/)
  end

  def scores_present?
    home_score.present? && away_score.present?
  end

  def update_score(home_score, away_score)
    return unless teams_present?

    if scores_present?
      adjust_score(home_score, away_score)
    else
      set_score(home_score, away_score)
    end
  end

  def dependent_games
    [
      Game.find_by(tournament_id: tournament_id, division_id: division_id, home_prereq_uid: "w#{bracket_uid}"),
      Game.find_by(tournament_id: tournament_id, division_id: division_id, home_prereq_uid: "l#{bracket_uid}"),
      Game.find_by(tournament_id: tournament_id, division_id: division_id, away_prereq_uid: "w#{bracket_uid}"),
      Game.find_by(tournament_id: tournament_id, division_id: division_id, away_prereq_uid: "l#{bracket_uid}")
    ].compact
  end

  private

  def set_score(home_score, away_score)
    Games::SetScoreJob.perform_now(
      game: self,
      home_score: home_score,
      away_score: away_score
    )
  end

  def adjust_score(home_score, away_score)
    Games::AdjustScoreJob.perform_now(
      game: self,
      home_score: home_score,
      away_score: away_score
    )
  end

  def update_bracket
    return unless self.score_confirmed
    #TODO return if pool game
    Games::UpdateBracketJob.perform_later(game_id: self.id)
  end
end
