class ScoreDispute < ApplicationRecord
  belongs_to :tournament
  belongs_to :game
  belongs_to :user

  acts_as_paranoid

  validates_presence_of :tournament
  validates_presence_of :game

  STATES = %w(open resolved)
  validates :status, inclusion: { in: STATES }

  after_initialize do
    self.status ||= 'open'
  end

  def resolve!
    status = 'resolved'
    save!
  end
end
