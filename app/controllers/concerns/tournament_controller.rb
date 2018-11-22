module TournamentController
  extend ActiveSupport::Concern

  included do
    before_action :load_tournament
    around_action :set_time_zone
  end

  def current_tournament
    @tournament
  end

  private

  def load_tournament
    @tournament = Tournament
      .includes(:map)
      .find_by!(handle: request.subdomain)
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { render 'login/404', layout: 'login', status: :not_found }
      format.any  { head :not_found }
    end
  end

  def set_time_zone(&action)
    tz = Time.find_zone(@tournament.timezone) || Time.zone
    Time.use_zone(tz, &action)
  end
end
