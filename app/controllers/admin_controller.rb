class AdminController < ApplicationController
  include TournamentConcern
  include AdminErrorHandling

  abstract!

  layout 'admin'

  helper UiHelper

  respond_to :html

  before_action :load_tournament
  before_action :authenticate_user!
  before_action :authenticate_tournament_user!
  before_action :set_tournament_cookie

  protected

  def authenticate_tournament_user!
    unless current_user.is_tournament_user?(@tournament.id) || current_user.staff?
      redirect_to new_user_session_path
    end
  end

  def set_tournament_cookie
    cookies.signed['tournament.id'] = {
      value: @tournament.id,
      domain: :all
    }
    cookies.signed['tournament.expires_at'] = {
      value: 30.minutes.from_now,
      domain: :all
    }
  end
end
