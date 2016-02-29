class Division < ActiveRecord::Base
  belongs_to :tournament
  has_many :teams, dependent: :nullify
  has_many :games, dependent: :destroy

  validates_presence_of :tournament, :name
  validates_uniqueness_of :name, scope: :tournament

  after_create :create_games
  after_update :update_games

  class InvalidNumberOfTeams < StandardError; end
  class InvalidSeedRound < StandardError; end
  class AmbiguousSeedList < StandardError; end

  def bracket
    @bracket ||= Bracket.find_by(name: self.bracket_type)
  end

  def dirty_seed?
    Divisions::DirtySeedJob.perform_now(division: self)
  end

  def seeded?
    games.where.not(home: nil).exists?
  end

  def seed(seed_round = 1)
    Divisions::SeedJob.perform_now(division: self, seed_round: seed_round)
  end

  private

  def create_games
    Divisions::CreateGamesJob.perform_later(
      tournament_id: tournament_id,
      division_id: id,
      template: bracket.template
    )
  end

  def update_games
    return unless self.bracket_type_changed?
    self.games.destroy_all
    @bracket = Bracket.find_by(name: self.bracket_type)

    Divisions::CreateGamesJob.perform_later(
      tournament_id: tournament_id,
      division_id: id,
      template: bracket.template
    )
  end
end
