class FieldsController < ApplicationController
  before_action :load_tournament, only: [:index]

  def index
  end

  private

  def load_tournament
    if params[:tournament_id]
      @tournament = Tournament.friendly.find(params[:tournament_id])
    else
      @tournament = Tournament.friendly.find(params[:id])
    end
  end

  def field_params
    params.require(:field).permit(:name, :location)
  end
end
