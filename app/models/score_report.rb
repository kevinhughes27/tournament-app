class ScoreReport < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :game
  belongs_to :team
end
