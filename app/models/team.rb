class Team < ActiveRecord::Base
  include UpdateSet
  belongs_to :tournament
end
