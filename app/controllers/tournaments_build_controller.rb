class TournamentsBuildController < ApplicationController
  include Wicked::Wizard

  before_action :load_tournament, only: [:show, :update]
  before_action :authenticate_user!

  layout 'builder'

  steps :step1, :step2

  def show
    render_wizard
  end

  def update
    @tournament.update_attributes(tournament_params)
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
end
