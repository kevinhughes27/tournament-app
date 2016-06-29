class Field < ApplicationRecord
  include Limits
  LIMIT = 64

  has_many :games, dependent: :nullify
  belongs_to :tournament

  auto_strip_attributes :name

  validates_presence_of :tournament, :name
  validates_uniqueness_of :name, scope: :tournament
  validates :lat , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90, allow_blank: true }
  validates :long, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180, allow_blank: true }
  validates :geo_json, json: { allow_blank: true }

  serialize :geo_json, JSON

  def safe_to_delete?
    !Game.where(tournament_id: tournament_id, field_id: id).exists?
  end
end
