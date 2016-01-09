class AdminController < ApplicationController
  layout 'admin'

  helper UiHelper

  responders :flash
  respond_to :html

  before_action :load_tournament
  before_action :store_tournament
  before_action :store_location
  before_action :authenticate_user!
  before_action :set_responder_action

  def respond_with(obj)
    super @tournament, :admin, obj
  end

  def load_tournament
    if params[:tournament_id]
      @tournament = tournament_scope.find(params[:tournament_id])
    else
      @tournament = tournament_scope.find(params[:id])
    end
  end

  def store_tournament
    return unless request.get?
    session[:tournament_id] = @tournament.id
    session[:tournament_friendly_id] = @tournament.friendly_id
  end

  def store_location
    return unless request.get?
    session[:previous_url] = request.fullpath
  end

  def set_responder_action
    @action = :show
  end

  private

  def tournament_scope
    Tournament.friendly
  end
end
