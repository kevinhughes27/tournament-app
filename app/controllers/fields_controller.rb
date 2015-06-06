class FieldsController < ApplicationController
  before_action :load_tournament, only: [:index, :create]

  def index
  end

  def create
    if @tournament.update_attributes(tournament_params)
      head :ok
    else
      head :unprocessible_entity
    end
  end

  private

  def load_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def tournament_params
    params.require(:tournament).permit(
      :zoom,
      :lat,
      :long
    )
  end

  def field_params
    params.require(:field).permit(:name, :location)
  end
end
