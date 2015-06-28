class Admin::MapsController < AdminController

  def new
    @map = @tournament.build_map(
      lat: 56.0,
      long: -96.0,
      zoom: 4
    )
  end

  def create
    @map = @tournament.build_map(map_params)

    if @map.save
      redirect_to @map, notice: 'Map was successfully created.'
    else
      render :new
    end
  end

  private

  def map_params
    params.require(:map).permit(
      :lat,
      :long,
      :zoom
    )
  end
end
