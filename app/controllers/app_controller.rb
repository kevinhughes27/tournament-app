class AppController < ApplicationController
  layout 'app'

  def show
    @tournament = Tournament.friendly.find(params[:tournament_id])
    @map = @tournament.map
    @fields = @tournament.fields

    render :show
  end

end
