require_relative 'structure'

module BracketDb
  @registry = {}

  class << self
    def init
      Dir["#{File.dirname(__FILE__)}/structures/*.rb"].each {|f| require f}
    end

    def define(name, &block)
      structure = Structure.new
      structure.instance_eval(&block)
      @registry[name] = structure
    end

    def all
      @registry
    end

    def where(teams:, days:)
      @registry.select{ |s| s.teams == teams && s.days == days }
    end

    def find(handle:)
      @registry[handle]
    end

    def print(handle)
      pp @registry[handle]
    end
  end
end
