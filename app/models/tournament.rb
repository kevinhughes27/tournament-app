class Tournament < ActiveRecord::Base
  extend FriendlyId
  friendly_id :handle

  has_many :games
  has_many :teams
  has_many :fields

  validates_presence_of :handle
  validates_format_of   :handle, with: /\A[a-zA-Z0-9]+([\.\-\_]+[a-zA-Z0-9]+)*\Z/

  before_validation :set_handle

  def location
    "[#{lat}, #{long}]"
  end

  private

  def set_handle
    self.handle = self.name.gsub(' ', '-').downcase
  end

end
