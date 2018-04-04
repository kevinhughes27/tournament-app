module TournamentConcern
  extend ActiveSupport::Concern

  included do
    before_action :load_tournament

    def load_tournament
      @tournament = Tournament
        .includes(:map)
        .find_by!(handle: request.subdomain)
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end

  def current_tournament
    @tournament
  end
end
