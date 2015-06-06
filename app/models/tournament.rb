class Tournament < ActiveRecord::Base
	has_many :games
	has_many :teams
	has_many :fields
end
