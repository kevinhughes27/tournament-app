require_relative 'to_tree'

module BracketDb
  class Structure
    def initialize(handle:, name:, description:, teams:, days:, games:, places:)
      @handle = handle
      @name = name
      @description = description
      @teams = teams
      @days = days
      @games = games
      @places = places
    end

    attr_reader :name,
      :description,
      :teams,
      :days

    def pools
      @games.map{ |g| g[:pool] }.compact.uniq
    end

    def to_tree
      @bracket_tree ||= BracketDb::to_tree(@games)
    end

    def template
      {
        games: @games,
        places: @places
      }
    end

    def to_json
      {
        handle: @handle,
        name: @name,
        description: @description,
        teams: @teams,
        days: @days,
        games: @games,
        places: @places,
        pools: pools,
        bracket_tree: to_tree
      }
    end
  end
end
