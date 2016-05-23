module LoadTournament
  extend ActiveSupport::Concern

  included do
    before_action :load_tournament

    def load_tournament
      @tournament = Tournament.find_by!(handle: request.subdomain)
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end
end
