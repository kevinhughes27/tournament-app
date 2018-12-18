class Division < ApplicationRecord
  include Limits
  LIMIT = 12

  attr_reader :change_message

  belongs_to :tournament

  has_many :seeds, dependent: :destroy
  has_many :teams, through: :seeds

  has_many :games, dependent: :destroy
  has_many :pool_results, dependent: :destroy
  has_many :places, dependent: :destroy

  auto_strip_attributes :name

  validates :name, presence: true, uniqueness: { scope: :tournament }
  validates :num_teams, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :num_days, presence: true, numericality: {greater_than_or_equal_to: 0}
  validate :validate_bracket_type

  def bracket
    @bracket ||= BracketDb.find(handle: self.bracket_type)
  end

  delegate :template, to: :bracket

  def pools
    bracket.pools.map{ |p| Pool.new(self, p) }
  end

  def dirty_seed?
    DirtySeedCheck.perform(self)
  end

  def validate_bracket_type
    errors.add(:bracket_type, 'is invalid') unless bracket.present?
  end
end
