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

  after_commit :create_games, on: :create
  after_commit :create_places, on: :create
  after_update :update_bracket

  scope :un_seeded, -> { where(seeded: false) }

  def bracket
    @bracket ||= Bracket.find_by(handle: self.bracket_type)
  end

  def pools
    bracket.pools.map{ |p| Pool.new(self, p) }
  end

  def dirty_seed?
    DirtySeedCheck.perform(self)
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
    CreateGamesJob.perform_later(
      tournament_id: tournament_id,
      division_id: id,
      template: bracket.template
    )
  end

  def create_places
    CreatePlacesJob.perform_later(
      tournament_id: tournament_id,
      division_id: id,
      template: bracket.template
    )
  end

  def update_bracket
    return unless self.bracket_type_changed?
    self.update_column(:seeded, false)

    bracket = Bracket.find_by(handle: self.bracket_type)

    Divisions::ChangeBracketJob.perform_later(
      tournament_id: tournament_id,
      division_id: id,
      new_template: bracket.template
    )
  end

  def validate_bracket_type
    errors.add(:bracket_type, 'is invalid') unless bracket.present?
  end
end
