require_relative 'pools'
require_relative 'brackets'

module BracketDb
  class Structure

    def initialize
      @name = ''
      @description = ''
      @teams = 0
      @days = 0
      @games = []
      @places = []
    end

    def name(value)
      @name = value
    end

    def description(value)
      @description = value
    end

    def teams(value)
      @teams = value
    end

    def num_teams
      @teams
    end

    def days(value)
      @days = value
    end

    def pool(template, identifier, seeds)
      pool_games = Pools[template]

      pool_games.each do |game|
        game[:pool] = identifier
        game[:home_prereq] = seeds[ game[:home_pool_seed] - 1 ]
        game[:away_prereq] = seeds[ game[:away_pool_seed] - 1 ]
      end

      @games += pool_games
    end

    def pools
      @games.map{ |g| g[:pool] }.compact.uniq
    end

    def bracket(template)
      bracket_games = Brackets[template]
      @games += bracket_games
    end

    def games(&block)
      @games += block.call
    end

    def to_tree
      @bracket_tree ||= BracketDb::to_tree(@games)
    end

    def places(game_uids)
      offset = @places.size
      @places += game_uids.each_with_index.map do |uid, idx|
        { position: idx + 1 + offset, prereq: uid}
      end
    end

    def template
      {
        games: @games,
        places: @places
      }
    end
  end
end
