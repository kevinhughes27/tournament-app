require_relative 'stages'

module BracketDb
  class Structure
    attr_reader :stages

    def initialize
      @stages = []
    end

    def stage(type, &block)
      new_stage = { type => build_stage(type).instance_eval(&block) }
      @stages << new_stage
    end

    private

    def build_stage(type)
      stage_types = {
        pools: PoolStage,
        bracket: BracketStage,
        results: ResultsStage
      }

      stage_types[type].new
    end
  end
end
