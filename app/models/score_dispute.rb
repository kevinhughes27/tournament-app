class ScoreDispute < ApplicationRecord
  belongs_to :tournament
  belongs_to :game
  belongs_to :user, optional: true

  acts_as_paranoid

  STATES = %w(open resolved)
  validates :status, inclusion: { in: STATES }

  default_scope { where(status: 'open') }
  scope :open, -> { where(status: 'open') }

  after_initialize do
    self.status ||= 'open'
  end

  def resolve!
    self.status = 'resolved'
    save!
  end
end
