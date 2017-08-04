class Admin::DivisionsController < AdminController
  before_action :load_division, only: [:show, :edit, :update, :destroy, :update_teams, :seed]

  def index
    @divisions = @tournament.divisions.includes(:teams, games: [:home, :away])
  end

  def show
    @bracket_tree = BracketDb::to_tree(@division.games)
  end

  def edit
  end

  def new
    @division = @tournament.divisions.build
    @division.bracket_type = 'USAU 8.1'
  end

  def create
    @division = DivisionCreate.perform(@tournament, division_params)
    flash[:notice] = 'Division was successfully created.'
    redirect_to admin_division_path(@division)
  rescue DivisionCreate::Failed => e
    @division = e.division
    render :new
  end

  def update
    DivisionUpdate.perform(@division, division_params, params[:confirm])
    flash[:notice] = 'Division was successfully updated.'
    redirect_to admin_division_path(@division)
  rescue ConfirmationRequired
    render partial: 'confirm_update', status: :unprocessable_entity
  rescue DivisionUpdate::Failed => e
    @division = e.division
    render :edit
  end

  def destroy
    DivisionDelete.perform(@division, params[:confirm])
    flash[:notice] = 'Division was successfully destroyed.'
    redirect_to admin_divisions_path
  rescue ConfirmationRequired
    render partial: 'confirm_delete', status: :unprocessable_entity
  rescue DivisionDelete::Failed => e
    flash[:error] = 'Division could not be deleted.'
    render :show
  end

  def seed_form
  end

  def seed
    SeedDivision.perform(
      division: @division,
      team_ids: params[:team_ids],
      seeds: params[:seeds],
      confirm: params[:confirm]
    )
    flash[:notice] = 'Division seeded'
    redirect_to admin_division_path(@division)
  rescue ConfirmationRequired
    render partial: 'confirm_seed', status: :unprocessable_entity
  rescue SeedDivision::Failed => e
    flash[:seed_error] = e.message
  end

  private

  def load_division
    @division = @tournament.divisions.includes(:teams, games: [:home, :away, :score_reports, :score_disputes]).find(params[:id])
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
