class Team < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :division

  validates_presence_of :tournament, :name
  validates_uniqueness_of :name, scope: :tournament
end
