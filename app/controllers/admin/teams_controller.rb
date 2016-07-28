require 'csv'

class Admin::TeamsController < AdminController
  before_action :load_team, only: [:show, :update, :destroy]
  before_action :check_update_safety, only: [:update]
  before_action :check_delete_safety, only: [:destroy]

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
      flash[:notice] = 'Team was successfully create.'
      redirect_to admin_team_path(@team)
    else
      flash[:error] = 'Team could not be created.'
      render :new
    end
  end

  def update
    @team.update_attributes(team_params)
    if @team.errors.present?
      flash[:error] = 'Team could not be updated.'
      render :show
    else
      flash[:notice] = 'Team was successfully updated.'
      redirect_to admin_team_path(@team)
    end
  end

  def destroy
    @team.destroy()
    flash[:notice] = 'Team was successfully destroyed.'
    redirect_to admin_teams_path
  end

  def sample_csv
    csv = CSV.generate do |csv|
      csv << ['Name', 'Email', 'Phone', 'Division', 'Seed']
      csv << ['Swift', 'swift@gmail.com', '613-979-4997', 'Open', '1']
    end

    respond_to do |format|
      format.csv { send_data csv, filename: 'sample_teams.csv' }
    end
  end

  def import_csv
    file = params[:csv_file].path
    ignore = params[:match_behaviour] == 'ignore'

    importer = TeamCsvImporter.new(@tournament, file, ignore)
    importer.run!

    flash[:notice] = 'Teams imported successfully'
    redirect_to action: :index
  rescue => e
    flash[:alert] = "Error importing teams"
    flash[:import_error] = "Row: #{rowNum} #{e}"
    redirect_to action: :index
  end

  private

  def check_update_safety
    @team.assign_attributes(team_params)
    return if @team.update_safe?

    # this is correct since as long as we don't render we continue
    # with the controller action
    if !@team.allow_change?
      render partial: 'unable_to_update', status: :not_allowed
    elsif !(params[:confirm] == 'true' || @team.safe_to_change?)
      render partial: 'confirm_update', status: :unprocessable_entity
    end
  end

  def check_delete_safety
    if !@team.allow_delete?
      render partial: 'unable_to_delete', status: :not_allowed
    elsif !(params[:confirm] == 'true' || @team.safe_to_delete?)
      render partial: 'confirm_delete', status: :unprocessable_entity
    end
  end

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
