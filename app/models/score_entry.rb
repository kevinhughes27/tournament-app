class ScoreEntry < ApplicationRecord
  belongs_to :tournament
  belongs_to :game
  belongs_to :user

  belongs_to :home, class_name: 'Team', foreign_key: :home_id
  belongs_to :away, class_name: 'Team', foreign_key: :away_id

  acts_as_paranoid

  validates_presence_of :home_score
  validates_presence_of :away_score
end
