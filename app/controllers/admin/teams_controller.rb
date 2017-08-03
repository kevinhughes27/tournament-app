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
    TeamUpdate.perform(@team, team_params, params[:confirm])
    flash[:notice] = 'Team was successfully updated.'
    redirect_to admin_team_path(@team)
  rescue ConfirmationRequired
    render partial: 'confirm_update', status: :unprocessable_entity
  rescue TeamUpdate::UnableToUpdate
    render partial: 'unable_to_update', status: :not_allowed
  rescue StandardError
    render :show
  end

  def destroy
    TeamDelete.perform(@team, params[:confirm])
    flash[:notice] = 'Team was successfully destroyed.'
    redirect_to admin_teams_path
  rescue ConfirmationRequired
    render partial: 'confirm_delete', status: :unprocessable_entity
  rescue UnableToDelete
    render partial: 'unable_to_delete', status: :not_allowed
  rescue StandardError
    flash[:error] = 'Team could not be deleted.'
    render :show
  end

  def sample_csv
    respond_to do |format|
      format.csv { send_data TeamCsv.sample, filename: 'sample_teams.csv' }
    end
  end

  def import_csv
    file = params[:csv_file].path
    ignore = params[:match_behaviour] == 'ignore'

    TeamCsvImport.perform(@tournament, file, ignore)

    flash[:notice] = 'Teams imported successfully'
    redirect_to action: :index
  rescue TeamCsvImport::Failed => e
    flash[:import_error] = "Row: #{e.row_num} #{e.message}"
    redirect_to action: :index
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
