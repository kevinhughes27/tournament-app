class Admin::MapsController < AdminController

  def new
    @map = @tournament.build_map(
      lat: 56.0,
      long: -96.0,
      zoom: 4
    )
  end

  def show
    @map = @tournament.map
  end

  def create
    @map = @tournament.build_map(map_params)

    if @map.save
      redirect_to admin_tournament_fields_path(@tournament), notice: 'Map was successfully saved.'
    else
      render :new
    end
  end

  def update
    @map = @tournament.map

    if @map.update(map_params)
      redirect_to [:admin, @tournament, @map], notice: 'Map was successfully updated.'
    else
      render :show
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
