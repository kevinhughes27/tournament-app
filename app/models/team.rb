class Team < ApplicationRecord
  include Limits
  LIMIT = 256

  belongs_to :tournament
  belongs_to :division

  auto_strip_attributes :name, :email, :phone

  validates_presence_of :tournament, :name
  validates_uniqueness_of :name, scope: :tournament

  validates_format_of :email, with: Devise.email_regexp, allow_blank: true
  validates :phone, phone: { possible: true, allow_blank: true }
  validates :seed, numericality: { allow_blank: true }
  validate :validate_division

  after_update :unassign_games, if: :division_id_changed?
  after_destroy :unassign_games
  after_destroy :delete_score_reports

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

  def unassign_games
    UnassignGamesJob.perform_later(
      tournament_id: tournament_id,
      team_id: id
    )
  end

  def delete_score_reports
    DeleteScoreReportsJob.perform_later(
      tournament_id: tournament_id,
      team_id: id
    )
  end

  def validate_division
    return unless division_id.present?
    errors.add(:division, 'is invalid') unless tournament.divisions.where(id: division_id).exists?
  end
end
