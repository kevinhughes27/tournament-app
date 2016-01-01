class AdminController < ApplicationController
  layout 'admin'

  helper UiHelper

  responders :flash
  respond_to :html

  before_filter :store_tournament
  before_action :authenticate_user!
  before_action :load_tournament
  # ensure access to tournament

  def respond_with(obj)
    super @tournament, :admin, obj
  end

  # used for post-login redirect (in ApplicationController)
  def store_tournament
    return unless request.get?
    session[:login_tournament_id] = params[:tournament_id]
  end

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
