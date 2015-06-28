class Map < ActiveRecord::Base
  belongs_to :tournament
  validates_presence_of :tournament, :lat, :long, :zoom

  def location
    "[#{lat}, #{long}]"
  end
end
