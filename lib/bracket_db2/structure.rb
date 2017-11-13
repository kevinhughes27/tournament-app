require_relative 'stages'

module BracketDb
  class Structure
    attr_reader :stages

    def initialize
      @stages = []
    end

    def stage(stage_type, &block)
      new_stage = { stage_type.to_s => stage_type.instance_eval(&block) }
      @stages << new_stage
    end
  end
end
