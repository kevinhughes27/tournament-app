class Admin::TournamentsController < AdminController
  skip_before_filter :load_tournament, only: [:new, :create, :index]

  def index
    @tournaments = Tournament.all
    render :index, layout: 'application'
  end

  def show
    @map = @tournament.map
  end

  def new
    @tournament = Tournament.new
    @map = @tournament.build_map(
      lat: 56.0,
      long: -96.0,
      zoom: 4
    )
  end

  def create
    @tournament = Tournament.new(tournament_params)

    if @tournament.save
      redirect_to new_tournament_admin_map_path(@tournament), notice: 'Tournament was successfully created.'
    else
      render :new
    end
  end

  def update
    if @tournament.update(tournament_params)
      redirect_to [:admin, @tournament], notice: 'Tournament was successfully updated.'
    else
      render :show
    end
  end

  def destroy
    @tournament.destroy
    redirect_to tournaments_url, notice: 'Tournament was successfully destroyed.'
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
end
