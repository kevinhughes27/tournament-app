class Field < ApplicationRecord
  include Limits
  LIMIT = 64

  has_many :games
  belongs_to :tournament

  auto_strip_attributes :name

  validates :name, presence: true, uniqueness: { scope: :tournament }
  validates :lat , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90, allow_blank: true }
  validates :long, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180, allow_blank: true }
  validates :geo_json, json: { allow_blank: true }

  serialize :geo_json, JSON

  def self.example_geo_json
    {
      type: "Feature",
      properties: {},
      geometry: {
        type: "Polygon",
        coordinates: [
          [
            [-75.61704058530103, 45.24560112337739],
            [-75.61682149825708, 45.24531101502135],
            [-75.61568837209097, 45.24573520582302],
            [-75.61590746188978, 45.2460253137602],
            [-75.61704058530103, 45.24560112337739]
          ]
        ]
      }
    }.to_json
  end
end
