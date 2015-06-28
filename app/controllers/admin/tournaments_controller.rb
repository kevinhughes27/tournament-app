class Admin::TournamentsController < AdminController
  skip_before_filter :load_tournament, only: [:new, :create, :index]

  def index
    @tournaments = Tournament.all
    render :index, layout: 'application'
  end

  def show
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)

    if @tournament.save
      redirect_to new_admin_tournament_map_path(@tournament), notice: 'Tournament was successfully created.'
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
      :description,
    )
  end
end
