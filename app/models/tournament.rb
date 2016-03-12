class Tournament < ActiveRecord::Base
  extend FriendlyId
  friendly_id :handle

  has_many :tournament_users
  has_many :users, through: :tournament_users

  has_one :map, dependent: :destroy
  accepts_nested_attributes_for :map

  has_many :fields, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :divisions, dependent: :destroy
  has_many :games, dependent: :destroy
  has_many :score_reports, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :handle, presence: true, uniqueness: true, format: /\A[a-zA-Z0-9]+([\.\-\_]+[a-zA-Z0-9]+)*\Z/
  validates :time_cap, presence: true, numericality: true
  validates_presence_of :tournament_users, on: :update
end
