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

  # returns true if seeding would result in changes
  # only for initial seed
  def dirty_seed?
    return true if self.teams.blank?
    return true unless seeded?

    teams = self.teams.order(:seed)
    seeds = self.teams.pluck(:seed).sort

    seeds.each_with_index do |seed, idx|
      return true unless seed == (idx+1)
    end

    game_uids = bracket.game_uids_for_round(1)
    games = Game.where(division_id: id, bracket_uid: game_uids)

    return true unless games.all?{ |g| g.valid_for_seed_round? }

    seats = games.pluck(:home_prereq_uid, :away_prereq_uid).flatten.uniq
    seats.reject!{ |s| !s.to_s.is_i? }
    num_seats = seats.size

    return true unless num_seats == teams.size

    games.each do |game|
      if game.home_prereq_uid.is_i?
        return true if game.home != teams[game.home_prereq_uid.to_i - 1]
      end

      if game.away_prereq_uid.is_i?
        return true if game.away != teams[game.away_prereq_uid.to_i - 1]
      end
    end

    return false
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
