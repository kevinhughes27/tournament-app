class AdminController < ApplicationController
  layout 'admin'

  helper UiHelper

  responders :flash
  respond_to :html

  before_action :load_tournament
  before_action :store_location
  before_action :authenticate_user!
  before_action :authenticate_tournament_user!
  before_action :set_admin_cookie

  protected

  unless Rails.application.config.consider_all_requests_local
    rescue_from ActiveRecord::RecordNotFound do
      render_admin_404
    end

    rescue_from Exception do |e|
      Rollbar.error(e)
      render_admin_500
    end
  end

  def render_admin_404
    respond_to do |format|
      format.html { render 'admin/404', status: :not_found }
      format.any  { head :not_found }
    end
  end

  def render_admin_500
    respond_to do |format|
      format.html { render 'admin/500', status: 500 }
      format.any  { head 500 }
    end
  end

  def respond_with(obj)
    super :admin, obj
  end

  def load_tournament
    @tournament = Tournament.friendly.find(request.subdomain)
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def store_location
    return unless request.get?
    session[:previous_path] = request.path.gsub('admin', '')
  end

  def authenticate_tournament_user!
    redirect_to new_user_session_path unless current_user.is_tournament_user?(@tournament.id)
  end

  def set_admin_cookie
    cookies[:td] = true
  end
end

class ActionController::Responder
  DEFAULT_ACTIONS_FOR_VERBS = {
    :post => :new,
    :patch => :show,
    :put => :show
  }
end
