class PlayerAppController < ApplicationController
  include TournamentController
  include ReactAppController

  app_name 'player_app'

  before_action :allow_frame

  def allow_frame
    response.headers["X-FRAME-OPTIONS"] = "ALLOWALL"
  end
end
