module TournamentConcern
  extend ActiveSupport::Concern

  included do
    before_action :load_tournament
  end

  def load_tournament
    @tournament = Tournament.find_by!(handle: request.subdomain)
  end
end
