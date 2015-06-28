class Map < ActiveRecord::Base
  belongs_to :tournmanent
  validates_presence_of :lat, :long, :zoom
end
