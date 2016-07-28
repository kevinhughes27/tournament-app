class PoolResult < ApplicationRecord
  belongs_to :tournament
  belongs_to :division
  belongs_to :team

  validates_presence_of :tournament,
                        :division,
                        :team,
                        :pool,
                        :position,
                        :wins,
                        :points

  validates_numericality_of :position, :wins, :points
end
