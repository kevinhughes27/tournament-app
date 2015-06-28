class Admin::TournamentsController < AdminController

  # GET /tournaments
  def index
    @tournaments = Tournament.all
  end

  # GET /tournaments/1
  def show
    @teams = Team.where(tournament_id: @tournament)
  end

  # GET /tournaments/new
  def new
    @tournament = Tournament.new
  end

  # POST /tournaments
  def create
    @tournament = Tournament.new(tournament_params)

    if @tournament.save
      redirect_to @tournament, notice: 'Tournament was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /tournaments/1
  def update
    if @tournament.update(tournament_params)
      redirect_to @tournament, notice: 'Tournament was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /tournaments/1
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
