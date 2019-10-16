require_relative 'components/pools'
require_relative 'components/brackets'
require_relative 'components/structure'

module BracketDb
  class DSL

    def initialize(handle)
      @handle = handle
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

    def days(value)
      @days = value
    end

    def pool(template_or_games, identifier, seeds)
      pool_games = if template_or_games.instance_of?(String)
        Pools[template_or_games]
      else
        template_or_games
      end

      pool_games.each do |game|
        game[:pool] = identifier
        game[:home_prereq] = seeds[ game[:home_pool_seed] - 1 ]
        game[:away_prereq] = seeds[ game[:away_pool_seed] - 1 ]
      end

      @games += pool_games
    end

    def bracket(template)
      bracket_games = Brackets[template]
      @games += bracket_games
    end

    def games(misc_games)
      @games += misc_games
    end

    def places(game_uids)
      offset = @places.size
      @places += game_uids.each_with_index.map do |uid, idx|
        { position: idx + 1 + offset, prereq: uid}
      end
    end

    def to_structure
      Structure.new(
        handle: @handle,
        name: @name,
        description: @description,
        teams: @teams,
        days: @days,
        games: @games,
        places: @places
      )
    end
  end
end
