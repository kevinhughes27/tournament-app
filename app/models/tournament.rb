class Tournament < ActiveRecord::Base
  extend FriendlyId
  friendly_id :handle

  has_many :tournament_users
  has_many :users, through: :tournament_users

  has_one :map, dependent: :destroy
  accepts_nested_attributes_for :map

  has_many :fields, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :brackets, dependent: :destroy
  has_many :games, dependent: :destroy
  has_many :score_reports, dependent: :destroy

  validates_presence_of :name, :handle, :time_cap
  validates_format_of   :handle, with: /\A[a-zA-Z0-9]+([\.\-\_]+[a-zA-Z0-9]+)*\Z/
  validates_numericality_of :time_cap
  # validate at least one user ...

  def app_link
    "/#{handle}"
  end

end
