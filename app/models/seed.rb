class Seed < ApplicationRecord
  belongs_to :tournament
  belongs_to :division
  belongs_to :team

  validates :tournament, presence: true
  validates :division, presence: true
  validates :team, presence: true, uniqueness: true
  validates :seed, presence: true, numericality: true
end
