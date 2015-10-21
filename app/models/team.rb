class Team < ActiveRecord::Base
  belongs_to :tournament
  validates_presence_of :tournament, :name, :division
  validates_uniqueness_of :name, scope: :tournament
end
