class Field < ActiveRecord::Base
  has_many :games
  belongs_to :tournament

  validates_presence_of :tournament, :name
  validates_uniqueness_of :name, scope: :tournament

  after_destroy :unassign_games

  serialize :geo_json, JSON

  private

  def unassign_games
    tournament.games.where(field: self).update_all(field_id: nil)
  end
end
