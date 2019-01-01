class Game < ApplicationRecord
  include Schedulable

  belongs_to :tournament
  belongs_to :division

  belongs_to :field, optional: true
  belongs_to :home, class_name: 'Team', foreign_key: :home_id, optional: true
  belongs_to :away, class_name: 'Team', foreign_key: :away_id, optional: true

  has_many :score_reports, dependent: :destroy
  has_many :score_entries, dependent: :destroy
  has_many :score_disputes, dependent: :destroy

  validates_presence_of :home_prereq,
                        :away_prereq,
                        :round
  validates_presence_of :pool, if: Proc.new{ |g| g.bracket_uid.nil? }
  validates_presence_of :bracket_uid, if: Proc.new{ |g| g.pool.nil? }
  validates_uniqueness_of :bracket_uid, scope: :division, if: :bracket_game?
  validates_presence_of :home_pool_seed, :away_pool_seed, if: :pool_game?

  validates_numericality_of :home_score, :away_score, allow_blank: true, greater_than_or_equal_to: 0

  before_save :set_confirmed
  after_commit :broadcast, on: :update

  scope :bracket_game, -> { where.not(bracket_uid: nil) }
  scope :has_team, -> { where('home_id IS NOT NULL or away_id IS NOT NULL') }
  scope :with_teams, -> { where('home_id IS NOT NULL and away_id IS NOT NULL') }
  scope :scored, -> { where(score_confirmed: true) }

  def self.from_template(tournament_id:, division_id:, template_game:)
    new(
      template_game.merge(
        tournament_id: tournament_id,
        division_id: division_id
      )
    )
  end

  def [](key)
    return home_name if key == :home_name
    return away_name if key == :away_name
    super
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

  def home_name
    home.present? ? home.name : home_prereq
  end

  def away_name
    away.present? ? away.name : away_prereq
  end

  def one_team_present?
    home.present? || away.present?
  end

  def teams_present?
    home.present? && away.present?
  end

  def confirmed?
    score_confirmed
  end

  def unconfirmed?
    !score_confirmed
  end

  def scores_present?
    home_score.present? && away_score.present?
  end

  def reset_score!
    self.home_score = nil
    self.away_score = nil
    self.score_reports.destroy_all
    self.score_disputes.destroy_all
  end

  def dependent_games
    Game.where(tournament_id: tournament_id, division_id: division_id, home_prereq: "W#{bracket_uid}")
    .or(Game.where(tournament_id: tournament_id, division_id: division_id, home_prereq: "L#{bracket_uid}"))
    .or(Game.where(tournament_id: tournament_id, division_id: division_id, away_prereq: "W#{bracket_uid}"))
    .or(Game.where(tournament_id: tournament_id, division_id: division_id, away_prereq: "L#{bracket_uid}"))
  end

  def prerequisite_games
    Game.bracket_game.where(tournament_id: tournament_id, division_id: division_id, bracket_uid: home_prereq.to_s.gsub(/W|L/,''))
    .or(Game.bracket_game.where(tournament_id: tournament_id, division_id: division_id, bracket_uid: away_prereq.to_s.gsub(/W|L/,'')))
  end

  def score_disputed
    score_disputes.present?
  end

  def resolve_disputes!
    score_disputes.map(&:resolve!)
    score_disputes.reload
  end

  private

  def broadcast
    Schema.subscriptions.trigger("gameUpdated", {}, self, scope: tournament_id)
  end

  def set_confirmed
    self.score_confirmed = self.home_score.present? && self.away_score.present?
    true
  end
end
