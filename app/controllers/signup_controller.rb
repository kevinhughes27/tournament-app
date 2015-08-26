class SignupController < ApplicationController
  layout 'landing'

  def new
    @tournament = Tournament.new
    @tournament.build_map(
      lat: 56.0,
      long: -96.0,
      zoom: 4
    )
  end

  def create
    @tournament = Tournament.new(tournament_params)

    if @tournament.save && @tournament.build_map(map_params).save
      redirect_to tournament_admin_path(@tournament), notice: 'Tournament was successfully created.'
    else
      render :new
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(
      :name,
      :handle,
      :description,
      :time_cap
    )
  end

  def map_params
    params.require(:tournament).permit(
      map_attributes: [:lat, :long, :zoom]
    )[:map_attributes]
  end

end
