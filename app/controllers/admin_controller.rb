class AdminController < ApplicationController
  layout 'admin'

  helper UiHelper

  responders :flash
  respond_to :html

  before_action :load_tournament
  before_filter :store_tournament
  before_action :authenticate_user!

  def respond_with(obj)
    super @tournament, :admin, obj
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

  # used for:
    # ensuring tournament_user in custom warden stratgey defined in user.rb
    # post-login redirect (in ApplicationController)
  def store_tournament
    return unless request.get?
    session[:login_tournament_id] = @tournament.friendly_id
    Thread.current[:login_tournament_id] = @tournament.id
  end
end
