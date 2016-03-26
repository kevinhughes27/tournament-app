class Team < ActiveRecord::Base
  include Limits
  LIMIT = 256

  belongs_to :tournament
  belongs_to :division

  validates_presence_of :tournament, :name
  validates_uniqueness_of :name, scope: :tournament

  after_update :unassign_games, if: Proc.new { |t| t.division_id_changed? }
  after_destroy :unassign_games

  def safe_to_delete?
    !Game.where(tournament_id: tournament_id, home_id: id).exists? &&
    !Game.where(tournament_id: tournament_id, away_id: id).exists?
  end

  def allow_delete?
    !Game.where(tournament_id: tournament_id, score_confirmed: true, division: division).exists?
  end

  private

  def unassign_games
    Teams::UnassignGamesJob.perform_later(
      tournament_id: tournament_id,
      team_id: id
    )
  end
end
