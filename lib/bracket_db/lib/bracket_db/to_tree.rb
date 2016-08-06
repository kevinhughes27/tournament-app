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
      roots = games.select { |g| g[:bracket_uid].present? && g[:bracket_uid].is_i? }
      roots.sort_by! { |g| g[:bracket_uid].to_i }

      roots.map { |r| add_node(r[:bracket_uid]) }
    end

    private

    def add_node(game_uid)
      game = games.detect { |g| g[:bracket_uid] == game_uid }

      if game
        add_inner_node(game)
      else
        add_leaf_node(game_uid)
      end
    end

    def add_inner_node(game)
      label = game[:bracket_uid]
      label = ActiveSupport::Inflector.ordinalize(label) if label.is_i?

      node = {
        label: label,
        home: game.try(:home_name),
        away: game.try(:away_name),
        has_teams: game.try(:teams_present?),
        round: game[:round],
        children: [
          home_child(game),
          away_child(game)
        ].compact
      }
      node
    end

    def home_child(game)
      home_uid = game[:home_prereq].to_s.gsub('W', '')
      if game[:seed_round] && game[:seed_round] > 0
        add_leaf_node(home_uid)
      else
        add_node(home_uid)
      end
    end

    def away_child(game)
      away_uid = game[:away_prereq].to_s.gsub('W', '')
      if game[:seed_round] && game[:seed_round] > 0
        add_leaf_node(away_uid)
      else
        add_node(away_uid)
      end
    end

    def add_leaf_node(uid)
      klass = uid.match(/L./) ? 'loser' : 'initial'
      return if klass = 'initial'

      node = {
        label: uid,
        round: game[:round],
        leaf: true,
        kind: klass
      }
      node
    end
  end
end
