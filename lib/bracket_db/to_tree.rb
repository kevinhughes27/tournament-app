require 'active_support/inflector'

module BracketDb
  def to_tree(games)
    TreeConverter.new(games).build
  end
  module_function :to_tree

  class TreeConverter
    attr_reader :games

    def initialize(games)
      @games = games
    end

    def build
      roots = games.select { |g| is_root?(g[:bracket_uid]) }

      roots.sort_by! { |g| g[:bracket_uid].to_i }

      roots.map { |r| add_node(r[:bracket_uid]) }
    end

    private

    def is_root?(game_uid)
      return false unless game_uid.present?

      return false if games.detect do |g|
        g[:home_prereq] == "W#{game_uid}" ||
        g[:away_prereq] == "W#{game_uid}"
      end
      true
    end

    def add_node(game_uid)
      game = games.detect { |g| g[:bracket_uid] == game_uid }
      return unless game

      node = {
        uid: game[:bracket_uid],
        home: game[:home_name] || game[:home_prereq],
        away: game[:away_name] || game[:away_prereq],
        round: game[:round],
        children: [
          home_child(game),
          away_child(game)
        ].compact
      }
      node
    end

    def home_child(game)
      return if game[:seed_round] && game[:seed_round] > 0
      home_uid = game[:home_prereq].to_s.gsub('W', '')
      add_node(home_uid)
    end

    def away_child(game)
      return if game[:seed_round] && game[:seed_round] > 0
      away_uid = game[:away_prereq].to_s.gsub('W', '')
      add_node(away_uid)
    end
  end
end
