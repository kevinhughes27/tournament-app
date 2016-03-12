class TournamentsBuildController < ApplicationController
  include Wicked::Wizard

  before_action :load_tournament, only: [:show, :update]
  before_action :authenticate_user!
  after_action :save_step

  layout 'builder'

  steps :step1, :step2

  def show
    init_map if step == :step2
    render_wizard
  end

  def update
    @tournament.update_attributes(tournament_params)
    flash[:animate] = "fadeIn" if step == steps.last
    render_wizard @tournament
  end

  private

  def tournament_params
    params.require(:tournament).permit(
      :name,
      :handle,
      :time_cap,
      map_attributes: [:lat, :long, :zoom]
    )
  end

  def load_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def init_map
    @tournament.build_map(
      lat: 56.0,
      long: -96.0,
      zoom: 4
    )
  end

  def save_step
    session[:previous_step] = request.path
  end

  def finish_wizard_path
    admin_url
  end
end
