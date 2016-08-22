class Admin::DivisionsController < AdminController
  before_action :load_division, only: [:show, :edit, :update, :destroy, :update_teams, :seed]

  def index
    @divisions = @tournament.divisions.includes(:teams, games: [:home, :away])
  end

  def show
  end

  def edit
  end

  def new
    @division = @tournament.divisions.build
    @division.bracket_type = 'USAU 8.1'
  end

  def create
    @division = @tournament.divisions.create(division_params)
    if @division.persisted?
      flash[:notice] = 'Division was successfully created.'
      redirect_to admin_division_path(@division)
    else
      flash[:error] = 'Division could not be created.'
      render :new
    end
  end

  def update
    update = DivisionUpdate.new(@division, division_params, params[:confirm])
    update.perform

    if update.succeeded?
      flash[:notice] = 'Division was successfully updated.'
      redirect_to admin_division_path(@division)
    elsif update.confirmation_required?
      render partial: 'confirm_update', status: :unprocessable_entity
    else
      flash[:error] = 'Division could not be updated.'
      render :edit
    end
  end

  def destroy
    delete = DivisionDelete.new(@division, params[:confirm])
    delete.perform

    if delete.succeeded?
      flash[:notice] = 'Division was successfully destroyed.'
      redirect_to admin_divisions_path
    elsif delete.confirmation_required?
      render partial: 'confirm_delete', status: :unprocessable_entity
    else
      flash[:error] = 'Division could not be deleted.'
      render :show
    end
  end

  def seed
    if request.post?
      seed = SeedDivision.new(@division)
      seed.perform

      if seed.succeeded?
        flash[:notice] = 'Division seeded'
        redirect_to admin_division_path(@division)
      elsif seed.confirmation_required?
        render partial: 'confirm_seed', status: :unprocessable_entity
      else
        flash[:error] = seed.message
        render :seed
      end
    end
  end

  def update_teams
    update = UpdateTeamSeeds.new(@division, params[:team_ids], params[:seeds])
    update.perform

    if update.succeeded?
      flash.now[:notice] = 'Seeds updated'
      render :seed
    else
      render partial: 'unable_to_update_teams', status: :not_allowed
    end
  end

  private

  def load_division
    @division = @tournament.divisions.includes(:teams, games: [:home, :away]).find(params[:id])
  end

  def division_params
    @bracket_params ||= params.require(:division).permit(
      :name,
      :num_teams,
      :num_days,
      :bracket_type
    )
  end
end
