class AdminNextController < ApplicationController
  include TournamentController
  include ReactAppController

  before_action :authenticate_user!

  app_name 'admin_next'
end
