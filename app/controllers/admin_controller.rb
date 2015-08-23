class AdminController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "nobo"

  before_action :load_tournament
  layout 'admin_lte_2'

  def load_tournament
    if params[:tournament_id]
      @tournament = Tournament.friendly.find(params[:tournament_id])
    else
      @tournament = Tournament.friendly.find(params[:id])
    end
  end
end
