class Field < ActiveRecord::Base
	has_many :games
	belongs_to :tournament
end
