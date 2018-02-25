class Admin::TeamsController < AdminController
  before_action :load_team, only: [:show, :update, :destroy]

  def index
    @teams = @tournament.teams.includes(:division)
  end

  def show
  end

  def new
    @team = @tournament.teams.build
  end

  def create
    @team = @tournament.teams.create(team_params)
    if @team.persisted?
      flash[:notice] = 'Team was successfully created.'
      redirect_to admin_team_path(@team)
    else
      render :new
    end
  end

  def update
    update = TeamUpdate.new(@team, team_params, confirm: params[:confirm])
    update.perform

    if update.succeeded?
      flash[:notice] = 'Team was successfully updated.'
      redirect_to admin_team_path(@team)
    elsif update.confirmation_required?
      render partial: 'confirm_update', status: :unprocessable_entity
    elsif update.not_allowed?
      render partial: 'unable_to_update', status: :not_allowed
    else
      render :show
    end
  end

  def destroy
    delete = TeamDelete.new(@team, confirm: params[:confirm])
    delete.perform

    if delete.succeeded?
      flash[:notice] = 'Team was successfully destroyed.'
      redirect_to admin_teams_path
    elsif delete.confirmation_required?
      render partial: 'confirm_delete', status: :unprocessable_entity
    elsif delete.halted?
      render partial: 'unable_to_delete', status: :not_allowed
    else
      flash[:error] = 'Team could not be deleted.'
      render :show
    end
  end

  def sample_csv
    respond_to do |format|
      format.csv { send_data TeamCsv.sample, filename: 'sample_teams.csv' }
    end
  end

  def import_csv
    file = params[:csv_file].path
    ignore = params[:match_behaviour] == 'ignore'

    import = TeamCsvImport.new(@tournament, file, ignore)
    import.perform

    if import.succeeded?
      flash[:notice] = 'Teams imported successfully'
      redirect_to action: :index
    else
      flash[:import_error] = "Row: #{import.row_num} #{import.message}"
      redirect_to action: :index
    end
  end

  private

  def load_team
    @team = @tournament.teams.find(params[:id])
  end

  def team_params
    @team_params ||= params.require(:team).permit(
      :name,
      :email,
      :phone,
      :division_id,
      :seed
    )
  end
end
