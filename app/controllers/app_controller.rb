class AppController < ApplicationController

  def show
    @tournament = Tournament.friendly.find(params[:tournament_id])
    render  :show
  end

end