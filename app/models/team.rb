class Team < ApplicationRecord
  include Limits
  LIMIT = 256

  belongs_to :tournament
  belongs_to :division, optional: true
  has_many :score_reports, dependent: :nullify

  auto_strip_attributes :name, :email, :phone

  validates :name, presence: true, uniqueness: { scope: :tournament }
  validates_format_of :email, with: Devise.email_regexp, allow_blank: true
  validates :phone, phone: { possible: true, allow_blank: true }
  validates :seed, numericality: { allow_blank: true }
  validate :validate_division

  after_update :unassign_games, if: :division_changed?
  after_destroy :unassign_games

  def safe_to_change?
    !Game.where(tournament_id: tournament_id, home_id: id).exists? &&
    !Game.where(tournament_id: tournament_id, away_id: id).exists?
  end

  def allow_change?
    !Game.where(tournament_id: tournament_id, division_id: division_id, score_confirmed: true).exists?
  end

  alias_method :safe_to_delete?, :safe_to_change?
  alias_method :allow_delete?, :allow_change?

  private

  def division_changed?
    saved_changes.include?('division_id')
  end

  def unassign_games
    games = Game.where(tournament_id: tournament_id, home_id: id)
    games.update_all(home_id: nil)

    games = Game.where(tournament_id: tournament_id, away_id: id)
    games.update_all(away_id: nil)
  end

  def validate_division
    return unless division_id.present?
    errors.add(:division, 'is invalid') unless tournament.divisions.where(id: division_id).exists?
  end
end
