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
    respond_with @team
  end

  def update
    @team.update_attributes(team_params)
    respond_with @team
  end

  def destroy
    @team.destroy()
    respond_with @team
  end

  def sample_csv
    csv = CSV.generate do |csv|
      csv << ['Name', 'Division', 'Seed']
      csv << ['Swift', 'Open', '1']
    end

    respond_to do |format|
      format.csv { send_data csv, filename: 'sample_teams.csv' }
    end
  end

  def import_csv
    file_path = params[:csv_file].path
    ignore = params[:match_behaviour] == 'ignore'

    @teams = @tournament.teams

    rowNum = 1
    Team.transaction do
      CSV.foreach(file_path, headers: true, :header_converters => lambda { |h| h.try(:downcase).strip }) do |row|
        rowNum += 1
        attributes = row.to_hash.with_indifferent_access
        attributes = csv_params(attributes)

        if attributes[:division]
          if division = Division.find_by(name: attributes[:division])
            attributes[:division] = division
          else
            attributes.delete(:division)
          end
        end

        if team = @teams.detect{ |t| t.name == attributes[:name] }
          next if ignore
          team.update_attributes!(attributes)
        else
          @tournament.teams.create!(attributes)
        end
      end
    end

    flash[:notice] = 'Teams imported successfully'
    redirect_to action: :index
  rescue => e
    flash[:alert] = "Error importing teams. Row: #{rowNum} #{e}"
    redirect_to action: :index
  end

  private

  def check_update_safety
    @team.assign_attributes(team_params)
    return if @team.update_safe?

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
      :id,
      :name,
      :email,
      :sms,
      :division_id,
      :seed
    )
  end

  def csv_params(attributes)
    attributes.slice(
      :name,
      :email,
      :sms,
      :division,
      :seed
    )
  end
end
