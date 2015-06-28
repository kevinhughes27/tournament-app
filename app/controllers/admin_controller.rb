class AdminController < ApplicationController
  before_action :load_tournament
  layout 'admin'

  def load_tournament
    if params[:tournament_id]
      @tournament = Tournament.friendly.find(params[:tournament_id])
    else
      @tournament = Tournament.friendly.find(params[:id])
    end
  end
end
