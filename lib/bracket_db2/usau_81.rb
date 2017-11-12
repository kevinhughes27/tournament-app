require 'pp'
require_relative './structure'

module BracketDb
  class USAU_81 < Structure
    stage PoolStage do
      pool 'A', '4.1', [1,3,6,8]
      pool 'B', '4.1', [2,4,5,7]
    end

    stage BracketStage do
      bracket '8.1'
    end

    def self.to_s
      pp stages
    end
  end
end
