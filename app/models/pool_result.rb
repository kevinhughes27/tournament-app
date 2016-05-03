class PoolResult < ApplicationRecord
  belongs_to :tournament
  belongs_to :division
  belongs_to :team
end
