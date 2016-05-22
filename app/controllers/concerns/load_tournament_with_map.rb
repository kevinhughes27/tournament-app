module LoadTournamentWithMap
  extend ActiveSupport::Concern

  included do
    before_action :set_map

    def load_tournament
      @tournament = Tournament.includes(:map).find_by(handle: request.subdomain)
    rescue ActiveRecord::RecordNotFound
      render_404
    end

    def set_map
      @map = @tournament.map
    end
  end
end
