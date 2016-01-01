module LoadTournamentWithMap
  extend ActiveSupport::Concern

  included do
    before_action :set_map

    def tournament_scope
      Tournament.includes(:map).friendly
    end

    def set_map
      @map = @tournament.map
    end
  end
end
