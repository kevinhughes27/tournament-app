class Bracket < ActiveRecord::Base
  belongs_to :tournament
  has_many :games, dependent: :destroy

  after_create :create_games
  after_update :update_games

  class InvalidNumberOfTeams < StandardError; end
  class InvalidSeedRound < StandardError; end
  class AmbiguousSeedList < StandardError; end

  def template
    @template ||= BracketDb[bracket_type]
  end

  def bracket_uids_for_round(round)
    template['games'].map{ |g| g['uid'] if g['round'] == round }.compact
  end

  # assumes teams are sorted by seed
  # can't sort here for re-seed
  def seed(teams, round = 1)
    game_uids = template[:games].map{ |g| g[:uid] if g[:round] == round }.compact
    games = Game.where(bracket_id: id, bracket_uid: game_uids)
    seats = games.pluck(:bracket_top, :bracket_bottom).flatten.uniq.size

    raise InvalidNumberOfTeams, "#{seats} seats but #{teams.size} teams present" unless seats == teams.size
    raise InvalidSeedRound unless games.all?{ |g| g.valid_for_seed_round? }

    games.each do |game|
      game.home = teams[ game.bracket_top.to_i - 1 ]
      game.away = teams[ game.bracket_bottom.to_i - 1 ]
      game.home_score = nil
      game.away_score = nil
      game.score_confirmed = false
      game.save!
    end

    reset(round)
  end

  def reset(round = 1)
    game_uids = template[:games].map{ |g| g[:uid] if g[:round] > round }.compact
    games = Game.where(bracket_id: id, bracket_uid: game_uids)

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
        bracket_uid: game[:uid],
        bracket_top: game[:top],
        bracket_bottom: game[:bottom]
      )
    end
  end

  def update_games
    return unless self.bracket_type_changed?
    self.games.destroy_all
    @template = BracketDb[bracket_type]
    create_games
  end
end
