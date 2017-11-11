module BracketDb
  class PoolStage
    def self.pool(identifier, type, input)
      "pool"
    end
  end

  class BracketStage
    def self.bracket(type)
      "bracket"
    end
  end
end
