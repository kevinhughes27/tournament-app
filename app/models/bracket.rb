class Bracket < ActiveRecord::Base
  TEMPLATE_PATH = Rails.root.join("db/brackets").freeze

  belongs_to :tournament
  has_many :games, dependent: :destroy

  after_create :create_games
  after_update :update_games

  class InvalidNumberOfTeams < StandardError; end
  class InvalidSeedRound < StandardError; end

  class << self
    #TODO return num_teams so I can filter the selection
    def types
      @types ||= begin
        types = Dir.entries(TEMPLATE_PATH)
        types.reject!{ |f| f == "." || f == ".."}
        types.map{ |t| t.gsub('.json', '') }
      end
    end
  end

  def template
    @template ||= load_template
  end

  def seed(teams, round = 1)
    game_uids = template[:games].map{ |g| g[:uid] if g[:round] == round }.compact
    games = Game.where(bracket_id: id, bracket_uid: game_uids)
    seats = games.size * 2

    raise InvalidNumberOfTeams, "#{seats} seats but #{teams.size} teams present" unless seats == teams.size
    raise InvalidSeedRound unless games.all?{ |g| g.valid_for_seed_round? }

    teams.sort_by{ |t| t.seed }

    games.each do |game|
      game.home = teams[ game.bracket_top.to_i - 1 ]
      game.away = teams[ game.bracket_bottom.to_i - 1 ]
      game.save
    end

    #TODO reset rounds greater than the seed round
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
    @template = load_template
    create_games
  end

  def load_template
    path = File.join(TEMPLATE_PATH, "#{bracket_type}.json")
    file = File.read(path)
    JSON.parse(file).with_indifferent_access
  end
end
