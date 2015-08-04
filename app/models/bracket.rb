class Bracket < ActiveRecord::Base
  TEMPLATE_PATH = Rails.root.join("db/brackets").freeze

  belongs_to :tournament
  has_many :games

  after_save :create_games

  class InvalidSeedRound < StandardError; end

  def template
    @template ||= load_template
  end

  # assumes that teams are already sorted by seed
  def seed(teams, round = 1)
    game_uids = template[:games].map{ |g| g[:uid] if g[:round] == round }
    games = Game.where(bracket_id: id, bracket_uid: game_uids)

    raise InvalidSeedRound unless games.all?{ |g| g.valid_for_seed_round? }

    games.each do |game|
      game.home = teams[ game.bracket_top.to_i ]
      game.away = teams[ game.bracket_bottom.to_i ]
      game.save
    end
  end

  private

  def create_games
    template[:games].each do |game|
      self.games.create!(
        bracket_uid: game[:uid],
        bracket_top: game[:top],
        bracket_bottom: game[:bottom]
      )
    end
  end

  def load_template
    path = File.join(TEMPLATE_PATH, "#{bracket_type}.json")
    file = File.read(path)
    JSON.parse(file).with_indifferent_access
  end
end
