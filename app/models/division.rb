class Division < ApplicationRecord
  include Limits
  LIMIT = 12

  attr_reader :change_message

  belongs_to :tournament
  has_many :teams, dependent: :nullify
  has_many :games, dependent: :destroy
  has_many :pool_results, dependent: :destroy
  has_many :places, dependent: :destroy

  has_many :bracket_games, -> { bracket_game }, class_name: 'Game'

  def pool_games(pool_uid)
    games.where(pool: pool_uid)
  end

  auto_strip_attributes :name

  validates_presence_of :tournament, :name
  validates_uniqueness_of :name, scope: :tournament
  validates :num_teams, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :num_days, presence: true, numericality: {greater_than_or_equal_to: 0}
  validate :validate_bracket_type

  scope :un_seeded, -> { where(seeded: false) }

  def bracket
    @bracket ||= Bracket.find_by(handle: self.bracket_type)
  end

  delegate :template, to: :bracket

  def pools
    bracket.pools.map{ |p| Pool.new(self, p) }
  end

  def dirty_seed?
    DirtySeedCheck.perform(self)
  end

  def safe_to_change?
    return true unless self.bracket_type_changed?
    check = SafeToUpdateBracketCheck.new(self)
    check.perform
    @change_message = check.message
    safe = check.succeeded?
    safe
  end

  def safe_to_seed?
    !games.where(score_confirmed: true).exists?
  end

  def safe_to_delete?
    !games.where(score_confirmed: true).exists?
  end

  def validate_bracket_type
    errors.add(:bracket_type, 'is invalid') unless bracket.present?
  end
end
