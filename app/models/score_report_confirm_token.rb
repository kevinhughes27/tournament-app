class ScoreReportConfirmToken < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :score_report

  validates_presence_of :tournament, :score_report

  before_create :add_token

  def path
    "#{id}?token=#{token}"
  end

  private

  def add_token
    begin
      self.token = SecureRandom.hex[0,10].upcase
    end while self.class.exists?(token: token)
  end
end
