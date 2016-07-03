class Game < ApplicationRecord
  belongs_to :tournament
  belongs_to :division
  belongs_to :field

  belongs_to :home, class_name: 'Team', foreign_key: :home_id
  belongs_to :away, class_name: 'Team', foreign_key: :away_id

  has_many :score_reports, dependent: :destroy
  has_many :score_entries, dependent: :destroy
  has_many :score_disputes, dependent: :destroy

  validates_presence_of :tournament
  validates_presence_of :division, :home_prereq_uid, :away_prereq_uid
  validates_presence_of :round
  validates_presence_of :pool, if: Proc.new{ |g| g.bracket_uid.nil? }
  validates_presence_of :bracket_uid, if: Proc.new{ |g| g.pool.nil? }
  validates_uniqueness_of :bracket_uid, scope: :division, if: :bracket_game?

  validates :start_time, date: true, if: Proc.new{ |g| g.start_time.present? }
  validates_presence_of :start_time, if: Proc.new{ |g| g.field.present? }

  validates_presence_of :field, if: Proc.new{ |g| g.start_time.present? }
  validate :validate_field
  validate :validate_field_conflict
  validate :validate_team_conflict
  validate :validate_schedule_conflicts

  validates_numericality_of :home_score, :away_score, allow_blank: true, greater_than_or_equal_to: 0

  before_save :set_confirmed
  after_save :broadcast

  scope :bracket_game, -> { where.not(bracket_uid: nil) }
  scope :pool_game, -> { where.not(pool: nil) }

  scope :assigned, -> { where.not(field_id: nil, start_time: nil) }
  scope :with_teams, -> { where('home_id IS NOT NULL or away_id IS NOT NULL') }
  scope :reported_unconfirmed, -> { includes(:score_reports).where(score_confirmed: false).where.not(score_reports: {id: nil})}

  def self.create_from_template!(tournament_id:, division_id:, template_game:)
    Game.create!(
      tournament_id: tournament_id,
      division_id: division_id,
      pool: template_game[:pool],
      round: template_game[:round],
      bracket_uid: template_game[:uid],
      home_prereq_uid: template_game[:home],
      away_prereq_uid: template_game[:away]
    )
  end

  def pool_game?
    pool.present?
  end

  def bracket_game?
    bracket_uid.present?
  end

  def tie?
    home_score == away_score
  end

  def winner
    return if home_score == away_score
    home_score > away_score ? home : away
  end

  def loser
    return if home_score == away_score
    home_score < away_score ? home : away
  end

  def score
    return unless confirmed?
    "#{home_score} - #{away_score}"
  end

  def home_name
    home.present? ? home.name : home_prereq_uid
  end

  def away_name
    away.present? ? away.name : away_prereq_uid
  end

  def name
    if teams_present?
      "#{home.name} vs #{away.name}"
    elsif bracket_uid.present?
      "#{bracket_uid} (#{home_name} vs #{away_name})"
    else
      "#{home_name} vs #{away_name}"
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

  def reset_score!
    self.home_score = nil
    self.away_score = nil
    self.score_reports.destroy_all
  end

  def dependent_games
    [
      Game.bracket_game.find_by(tournament_id: tournament_id, division_id: division_id, home_prereq_uid: "W#{bracket_uid}"),
      Game.bracket_game.find_by(tournament_id: tournament_id, division_id: division_id, home_prereq_uid: "L#{bracket_uid}"),
      Game.bracket_game.find_by(tournament_id: tournament_id, division_id: division_id, away_prereq_uid: "W#{bracket_uid}"),
      Game.bracket_game.find_by(tournament_id: tournament_id, division_id: division_id, away_prereq_uid: "L#{bracket_uid}")
    ].compact
  end

  def prerequisite_games
    [
      Game.bracket_game.find_by(tournament_id: tournament_id, division_id: division_id, bracket_uid: home_prereq_uid.to_s.gsub(/W|L/,'')),
      Game.bracket_game.find_by(tournament_id: tournament_id, division_id: division_id, bracket_uid: away_prereq_uid.to_s.gsub(/W|L/,'')),
    ].compact
  end

  def resolve_disputes!
    score_disputes.map(&:resolve!)
    score_disputes.reload
  end

  private

  def broadcast
    ActionCable.server.broadcast(
      "games_#{tournament_id}",
      Admin::GamesController.render(
        template: 'admin/games/_game.json.jbuilder',
        layout: false,
        locals: {game: self}
      )
    )
  end

  def set_confirmed
    self.score_confirmed = self.home_score.present? && self.away_score.present?
    true
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
      "home_prereq_uid IN (?) OR away_prereq_uid IN (?)", prereq_uids, prereq_uids
    ).where.not(id: id)

    if games.present?
      conflicting_game = games.first

      name = if prereq_uids.include? conflicting_game.home_prereq_uid
        conflicting_game.home_prereq_uid
      else
        conflicting_game.away_prereq_uid
      end

      errors.add(:base, "Team #{name} is already playing at #{start_time.to_formatted_s(:timeonly)}")
    end
  end

  def validate_schedule_conflicts
    return unless start_time_changed?
    return if start_time.blank?
    return if pool_game?

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
