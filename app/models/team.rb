class Team < ActiveRecord::Base
  include UpdateSet
  belongs_to :tournament
  validates_presence_of :tournament
  validates_uniqueness_of :name, scope: :tournament
end
