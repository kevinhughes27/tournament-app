class Tournament < ActiveRecord::Base
  extend FriendlyId
  friendly_id :handle

  has_one :map
  has_many :fields
  has_many :games
  has_many :teams
  has_many :score_reports

  validates_presence_of :handle
  validates_format_of   :handle, with: /\A[a-zA-Z0-9]+([\.\-\_]+[a-zA-Z0-9]+)*\Z/

  def app_link
    "/#{handle}"
  end

end
