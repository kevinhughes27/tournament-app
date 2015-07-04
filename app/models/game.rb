class Game < ActiveRecord::Base
  include UpdateSet
  belongs_to :field
  belongs_to :tournament
  belongs_to :home, :class_name => "Team", :foreign_key => :home_id
  belongs_to :away, :class_name => "Team", :foreign_key => :away_id
end
