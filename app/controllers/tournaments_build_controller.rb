class TournamentsBuildController < ApplicationController
  include Wicked::Wizard

  before_action :load_tournament, only: [:show, :update]
  before_action :authenticate_user!
  after_action :save_step

  layout 'builder'

  steps :step1, :step2

  def show
    render_wizard
  end

  def update
    @tournament.update_attributes(tournament_params)
    flash[:animate] = "fadeIn" if step == steps.last
    render_wizard @tournament
  end

  private

  def tournament_params
    tournament_params = params.require(:tournament).permit(
      :name,
      :handle,
      :time_cap,
      :location,
      map_attributes: [:id, :lat, :long, :zoom]
    )

    # don't touch updated_at yet. I want to know when the user has edited it
    tournament_params[:map_attributes][:updated_at] = @tournament.map.created_at

    tournament_params.merge!(timezone: Time.zone.name)
    tournament_params
  end

  def load_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def save_step
    session[:previous_step] = request.path
  end

  def finish_wizard_path
    admin_url(subdomain: @tournament.handle)
  end
end
