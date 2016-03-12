class AdminController < ApplicationController
  layout 'admin'

  helper UiHelper

  responders :flash
  respond_to :html

  before_action :load_tournament
  before_action :store_tournament
  before_action :store_location
  before_action :authenticate_user!
  before_action :authenticate_tournament_user!

  def respond_with(obj)
    super :admin, obj
  end

  def load_tournament
    @tournament = tournament_scope.find(request.subdomain)
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def store_tournament
    return unless request.get?
    session[:tournament_id] = @tournament.id
    session[:tournament_friendly_id] = @tournament.friendly_id
  end

  def store_location
    return unless request.get?
    session[:previous_url] = request.fullpath
    session[:previous_path] = request.path.gsub('admin', '')
  end

  def authenticate_tournament_user!
    redirect_to new_user_session_path unless current_user.is_tournament_user?(@tournament.id)
  end

  private

  def tournament_scope
    Tournament.friendly
  end
end

class ActionController::Responder
  DEFAULT_ACTIONS_FOR_VERBS = {
    :post => :new,
    :patch => :show,
    :put => :show
  }
end
