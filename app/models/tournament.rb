class Tournament < ApplicationRecord
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
  has_many :pool_results, dependent: :destroy
  has_many :places, dependent: :destroy
  has_many :score_reports, dependent: :destroy

  before_save :downcase_handle

  validates :name, presence: true, uniqueness: true
  validates :handle, presence: true,
                     uniqueness: true,
                     format: /\A[a-zA-Z0-9]+([\.\-\_]+[a-zA-Z0-9]+)*\Z/,
                     exclusion: { in: %w(www us ca jp) }

  validates :time_cap, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates_presence_of :tournament_users, on: :update

  def owner
    @owner ||= users.first
  end

  def reset_data!
    fields.destroy_all
    teams.destroy_all
    divisions.destroy_all
    games.destroy_all
    pool_results.destroy_all
    places.destroy_all
    score_reports.destroy_all
  end

  def downcase_handle
    self.handle.downcase!
  end

  def domain
    "#{Settings.ssl ? 'https' : 'http'}://#{handle}.#{Settings.domain}"
  end
end
