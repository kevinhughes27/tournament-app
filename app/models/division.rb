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

  def template
    bracket.template
  end

  def bracket_uids_for_round(round)
    template['games'].map{ |g| g['uid'] if g['round'] == round }.compact
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

    round = 1
    game_uids = template[:games].map{ |g| g[:uid] if g[:round] == round }.compact
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

  # assumes teams are sorted by seed
  # can't sort here for re-seed
  def seed(round = 1)
    teams = self.teams.order(:seed)
    seeds = teams.pluck(:seed).sort

    seeds.each_with_index do |seed, idx|
      raise AmbiguousSeedList, 'Ambiguous seed list' unless seed == (idx+1)
    end

    game_uids = template[:games].map{ |g| g[:uid] if g[:round] == round }.compact
    games = Game.where(division_id: id, bracket_uid: game_uids)

    raise InvalidSeedRound unless games.all?{ |g| g.valid_for_seed_round? }

    seats = games.pluck(:home_prereq_uid, :away_prereq_uid).flatten.uniq
    seats.reject!{ |s| !s.to_s.is_i? }
    num_seats = seats.size

    raise InvalidNumberOfTeams, "#{num_seats} seats but #{teams.size} teams present" unless num_seats == teams.size

    games.each do |game|
      game.home = teams[ game.home_prereq_uid.to_i - 1 ] if game.home_prereq_uid.is_i?
      game.away = teams[ game.away_prereq_uid.to_i - 1 ] if game.away_prereq_uid.is_i?
      game.home_score = nil
      game.away_score = nil
      game.score_confirmed = false
      game.save!
    end

    reset(round)
  end

  def reset(round = 1)
    game_uids = template[:games].map{ |g| g[:uid] if g[:round] > round }.compact
    games = Game.where(division_id: id, bracket_uid: game_uids)

    games.each do |game|
      game.home = nil
      game.away = nil
      game.home_score = nil
      game.away_score = nil
      game.score_confirmed = false
      game.save!
    end
  end

  private

  def create_games
    template[:games].each do |game|
      self.games.create!(
        tournament_id: tournament_id,
        round: game[:round],
        bracket_uid: game[:uid],
        home_prereq_uid: game[:home],
        away_prereq_uid: game[:away]
      )
    end
  end

  def update_games
    return unless self.bracket_type_changed?
    self.games.destroy_all
    @bracket = nil # break memoization
    create_games
  end
end
