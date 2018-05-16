module TournamentController
  extend ActiveSupport::Concern

  included do
    before_action :load_tournament
  end

  def current_tournament
    @tournament
  end

  def load_tournament
    @tournament = Tournament
      .includes(:map)
      .find_by!(handle: request.subdomain)
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
