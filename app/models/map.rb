class Map < ActiveRecord::Base
  belongs_to :tournament
  validates_presence_of :tournament, :lat, :long, :zoom

  validates :lat , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
  validates :long, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :zoom, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 20 }

  def edited?
    updated_at > created_at
  end
end
