class Team < ActiveRecord::Base
  include Limits
  LIMIT = 256

  belongs_to :tournament
  belongs_to :division

  validates_presence_of :tournament, :name
  validates_uniqueness_of :name, scope: :tournament

  after_update :unassign_games, if: Proc.new { |t| t.division_id_changed? }
  after_destroy :unassign_games

  # intended to be called after assign_attributes
  def update_safe?
    !(self.division_id_changed? || self.seed_changed?)
  end

  def safe_to_change?
    !Game.where(tournament_id: tournament_id, home_id: id).exists? &&
    !Game.where(tournament_id: tournament_id, away_id: id).exists?
  end

  def allow_change?
    !Game.where(tournament_id: tournament_id, score_confirmed: true, division: division).exists?
  end

  alias_method :safe_to_delete?, :safe_to_change?
  alias_method :allow_delete?, :allow_change?

  private

  def unassign_games
    Teams::UnassignGamesJob.perform_later(
      tournament_id: tournament_id,
      team_id: id
    )
  end
end
