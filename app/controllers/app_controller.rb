class AppController < ApplicationController

  def show
    @tournament = Tournament.friendly.find(params[:tournament_id])
    @fields = @tournament.fields

    render :show
  end

end
