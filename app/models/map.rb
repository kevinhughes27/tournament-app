class Map < ActiveRecord::Base
  belongs_to :tournament
  validates_presence_of :tournament, :lat, :long, :zoom

  def edited?
    updated_at > created_at
  end
end
