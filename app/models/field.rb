class Field < ActiveRecord::Base
  has_many :games
  belongs_to :tournament

  validates_uniqueness_of :name, scope: :tournament
end
