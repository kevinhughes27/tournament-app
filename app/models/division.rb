class Division < ApplicationRecord
  include Limits
  LIMIT = 12

  attr_reader :change_message

  belongs_to :tournament
  has_many :teams, dependent: :nullify
  has_many :games, dependent: :destroy
  has_many :pool_results, dependent: :destroy
  has_many :places, dependent: :destroy

  auto_strip_attributes :name

  validates_presence_of :tournament, :name
  validates_uniqueness_of :name, scope: :tournament
  validates :num_teams, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :num_days, presence: true, numericality: {greater_than_or_equal_to: 0}
  validate :validate_bracket_type

  after_create :create_games
  after_create :create_places
  after_update :update_games
  after_update :update_places

  scope :un_seeded, -> { where(seeded: false) }

  class InvalidNumberOfTeams < StandardError; end
  class InvalidSeedRound < StandardError; end
  class AmbiguousSeedList < StandardError; end

  def bracket
    @bracket ||= Bracket.find_by(handle: self.bracket_type)
  end

  def dirty_seed?
    Divisions::DirtySeedJob.perform_now(division: self)
  end

  def seed(seed_round = 1)
    Divisions::SeedJob.perform_now(division: self, seed_round: seed_round)
  end

  def safe_to_change?
    return true unless self.bracket_type_changed?
    safe, @change_message = Divisions::SafeToUpdateBracketJob.perform_now(division: self)
    safe
  end

  def safe_to_seed?
    !games.where(score_confirmed: true).exists?
  end

  def safe_to_delete?
    !games.where(score_confirmed: true).exists?
  end

  private

  def create_games
    Divisions::CreateGamesJob.perform_later(
      tournament_id: tournament_id,
      division_id: id,
      template: bracket.template
    )
  end

  def create_places
    Divisions::CreatePlacesJob.perform_later(
      tournament_id: tournament_id,
      division_id: id,
      template: bracket.template
    )
  end

  def update_games
    return unless self.bracket_type_changed?
    self.update_column(:seeded, false)
    self.games.destroy_all
    @bracket = Bracket.find_by(name: self.bracket_type)
    create_games
  end

  def update_places
    return unless self.bracket_type_changed?
    self.games.destroy_all
    @bracket = Bracket.find_by(name: self.bracket_type)
    create_places
  end

  def validate_bracket_type
    errors.add(:bracket_type, 'is invalid') unless bracket.present?
  end
end
