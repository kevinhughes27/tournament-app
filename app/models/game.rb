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
  validates_presence_of :start_time, if: Proc.new{ |g| g.field.present? }

  validates_presence_of :field, if: Proc.new{ |g| g.start_time.present? }
  validate :validate_field
  validate :validate_field_conflict
  validate :validate_team_conflict
  validate :validate_schedule_conflicts

  validates_numericality_of :home_score, :away_score, allow_blank: true, greater_than_or_equal_to: 0

  after_save :update_pool
  after_save :update_bracket
  after_save :update_places

  scope :assigned, -> { where.not(field_id: nil, start_time: nil) }
  scope :with_teams, -> { where('home_id IS NOT NULL or away_id IS NOT NULL') }
  scope :reported_unconfirmed, -> { includes(:score_reports).where(score_confirmed: false).where.not(score_reports: {id: nil})}

  def pool_game?
    pool.present?
  end

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

  def assigned?
    !unassigned?
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

  def playing_time_range
    (start_time)..(end_time - 1.minutes)
  end

  def confirmed?
    score_confirmed
  end

  def unconfirmed?
    !score_confirmed
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
      Game.find_by(tournament_id: tournament_id, division_id: division_id, home_prereq_uid: "W#{bracket_uid}"),
      Game.find_by(tournament_id: tournament_id, division_id: division_id, home_prereq_uid: "L#{bracket_uid}"),
      Game.find_by(tournament_id: tournament_id, division_id: division_id, away_prereq_uid: "W#{bracket_uid}"),
      Game.find_by(tournament_id: tournament_id, division_id: division_id, away_prereq_uid: "L#{bracket_uid}")
    ].compact
  end

  def prerequisite_games
    [
      Game.find_by(tournament_id: tournament_id, division_id: division_id, bracket_uid: home_prereq_uid.to_s.gsub(/W|L/,'')),
      Game.find_by(tournament_id: tournament_id, division_id: division_id, bracket_uid: away_prereq_uid.to_s.gsub(/W|L/,'')),
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

  def update_pool
    return if !self.pool_game?
    return unless self.confirmed?
    Divisions::UpdatePoolJob.perform_later(division: self.division, pool: self.pool)
  end

  def update_bracket
    return if self.pool_game?
    return unless self.confirmed?
    Divisions::UpdateBracketJob.perform_later(game_id: self.id)
  end

  def update_places
    return unless self.confirmed?
    Divisions::UpdatePlacesJob.perform_later(game_id: self.id)
  end

  def validate_field
    return if field_id.blank? || errors[:field].present?
    errors.add(:field, 'is invalid') unless tournament.fields.where(id: field_id).exists?
  end

  def validate_field_conflict
    return unless field_id_changed? || start_time_changed?
    return if field_id.blank? || start_time.blank?

    games = tournament.games.where(field_id: field_id, start_time: playing_time_range)
    games = games.where.not(id: id)

    if games.present?
      errors.add(:base, "Field #{field.name} is in use at #{start_time.to_formatted_s(:timeonly)} already")
    end
  end

  def validate_team_conflict
    return unless start_time_changed?
    return if start_time.blank?

    prereq_uids = [home_prereq_uid, away_prereq_uid].compact
    return unless prereq_uids.present?

    games = tournament.games.where(
      division: division,
      start_time: playing_time_range
    ).where(
      "home_prereq_uid = ? OR away_prereq_uid = ?", prereq_uids, prereq_uids
    ).where.not(id: id)

    if games.present?
      conflicting_game = games.first

      name = if prereq_uids.include? conflicting_game.home_prereq_uid
        conflicting_game.home.try(:name) || conflicting_game.home_prereq_uid
      else
        conflicting_game.away.try(:name) || conflicting_game.away_prereq_uid
      end

      errors.add(:base, "Team #{name} is already playing at #{start_time.to_formatted_s(:timeonly)}")
    end
  end

  def validate_schedule_conflicts
    return unless start_time_changed?
    return if start_time.blank?

    games = dependent_games.select { |dg| dg.start_time < end_time if dg.start_time }

    if games.present?
      errors.add(:base, "Game '#{bracket_uid}' must be played before game '#{games.first.bracket_uid}'")
    end

    games = prerequisite_games.select { |pg| pg.start_time >= start_time if pg.start_time }

    if games.present?
      errors.add(:base, "Game '#{bracket_uid}' must be played after game '#{games.first.bracket_uid}'")
    end
  end
end
