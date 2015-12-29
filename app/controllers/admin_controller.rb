class AdminController < ApplicationController
  layout 'admin'

  helper UiHelper

  before_action :load_tournament

  def load_tournament
    if params[:tournament_id]
      @tournament = Tournament.friendly.find(params[:tournament_id])
    else
      @tournament = Tournament.friendly.find(params[:id])
    end
  end

  def load_tournament_with_map
    if params[:tournament_id]
      @tournament = Tournament.includes(:map).friendly.find(params[:tournament_id])
    else
      @tournament = Tournament.includes(:map).friendly.find(params[:id])
    end

    @map = @tournament.map
  end
end
