require_relative 'stages'

module BracketDb
  class Structure
    @@stages = []

    def self.stages
      @@stages
    end

    def self.stage(stage_type, &block)
      @@stages << stage_type.instance_eval(&block)
    end
  end
end
