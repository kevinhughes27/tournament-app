class Field < ActiveRecord::Base
  has_many :games
  belongs_to :tournament

  validates_presence_of :tournament, :name
  validates_uniqueness_of :name, scope: :tournament

  after_destroy :unassign_games

  serialize :geo_json, JSON

  private

  def unassign_games
    Fields::UnassignGamesJob.perform_later(
      tournament_id: tournament_id,
      field_id: id
    )
  end
end
