class ScoreDispute < ApplicationRecord
  belongs_to :tournament
  belongs_to :game
  belongs_to :user

  acts_as_paranoid

  validates_presence_of :tournament
  validates_presence_of :game

  STATES = %w(open resolved)
  validates :status, inclusion: { in: STATES }

  default_scope { where(status: 'open') }

  after_initialize do
    self.status ||= 'open'
  end

  after_save :touch_game

  def resolve!
    self.status = 'resolved'
    save!
  end

  private

  def touch_game
    game.update_attributes(updated_at: Time.now)
  end
end
