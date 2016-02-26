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
    DirtySeedJob.perform_now(division: self)
  end

  def seeded?
    games.where.not(home: nil).exists?
  end

  def seed(round = 1)
    SeedDivisionJob.perform_now(division: self, round: round)
  end

  # 02/26/16 remove soon - I think this is now fully abstracted as a sub job
  # I likely only needed a method to break up the code of seed (it should
  # have been private )

  # def reset(round = 1)
  #   ResetRoundJob.perform_now(division: self, round: round)
  # end

  private

  def create_games
    CreateGamesJob.perform_later(
      tournament_id: tournament_id,
      division_id: id,
      template: bracket.template
    )
  end

  def update_games
    return unless self.bracket_type_changed?
    self.games.destroy_all
    @bracket = Bracket.find_by(name: self.bracket_type)

    CreateGamesJob.perform_later(
      tournament_id: tournament_id,
      division_id: id,
      template: bracket.template
    )
  end
end
