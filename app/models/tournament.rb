class Tournament < ApplicationRecord
  has_many :tournament_users
  has_many :users, through: :tournament_users
  validates_presence_of :tournament_users, on: :update

  has_one :map, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :fields, dependent: :destroy
  has_many :divisions, dependent: :destroy
  has_many :seeds, dependent: :destroy
  has_many :games, dependent: :destroy
  has_many :pool_results, dependent: :destroy
  has_many :places, dependent: :destroy
  has_many :score_reports, dependent: :destroy
  has_many :score_entries, dependent: :destroy
  has_many :score_disputes, dependent: :destroy

  before_save :downcase_handle

  validates :name, presence: true, uniqueness: true
  validates :handle, presence: true,
                     uniqueness: true,
                     format: /\A[a-zA-Z0-9]+([\.\-\_]+[a-zA-Z0-9]+)*\Z/,
                     exclusion: { in: %w(www us ca jp) }

  validates :score_submit_pin,
    length: {is: 4}, allow_blank: true,
    format: /\A[0-9]+\Z/

  GAME_CONFIRM_SETTINGS = %w(single multiple)
  validates :game_confirm_setting, inclusion: { in: GAME_CONFIRM_SETTINGS }

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
    score_entries.destroy_all
    score_disputes.destroy_all
  end

  def downcase_handle
    self.handle.downcase!
  end

  def url
    "#{protocol}://#{domain}"
  end

  def admin_url
    "#{protocol}://#{domain}/admin"
  end

  def protocol
    Rails.env.production? ? 'https' : 'http'
  end

  def domain
    "#{handle}.#{Settings.host}"
  end

  def subdomain
    handle
  end
end
