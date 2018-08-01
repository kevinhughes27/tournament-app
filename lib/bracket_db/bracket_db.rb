require_relative 'dsl'

module BracketDb
  @registry = {}

  class << self
    def init
      Dir["#{File.dirname(__FILE__)}/structures/*.rb"].each {|f| require f}
    end

    def define(handle, &block)
      dsl = DSL.new(handle)
      dsl.instance_eval(&block)
      structure = dsl.to_structure
      @registry[handle] = structure
    end

    def all
      @registry
    end

    def where(teams:, days:)
      @registry.values.select do |bracket|
        bracket.teams == teams && bracket.days == days
      end
    end

    # remove when admin next ships
    def options(teams:, days:)
      @registry.select do |handle, bracket|
        bracket.teams == teams && bracket.days == days
      end
    end

    def find(handle:)
      @registry[handle]
    end

    def print(handle)
      pp @registry[handle]
    end
  end
end
