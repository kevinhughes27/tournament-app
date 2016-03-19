class TournamentUser < ActiveRecord::Base
  include Limits
  LIMIT = 32

  belongs_to :tournament
  belongs_to :user
  validates :user, uniqueness: { scope: :tournament }

  def model_name
    User.model_name
  end
end
