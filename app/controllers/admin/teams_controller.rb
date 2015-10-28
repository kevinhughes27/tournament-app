require 'csv'

class Admin::TeamsController < AdminController

  def index
    @teams = @tournament.teams
  end

  def show
    @team = @tournament.teams.find(params[:id])
  end

  def new
    @team = @tournament.teams.build
  end

  def create
    @team = @tournament.teams.build(team_params)

    if @team.save
      render :show
    else
      render :new
    end
  end

  def update
    @team = @tournament.teams.find(params[:id])
    @team.update_attributes(team_params)
    render :show
  end

  def sample_csv
    csv = CSV.generate do |csv|
      csv << ['Name', 'Division', 'Seed']
      csv << ['Swift', 'Open', '1']
    end

    respond_to do |format|
      format.csv { send_data csv }
    end
  end

  def import_csv
    file_path = params[:csv_file].path
    ignore = params[:match_behaviour] == 'ignore'

    @teams = @tournament.teams

    Team.transaction do
      CSV.foreach(file_path, headers: true, :header_converters => lambda { |h| h.try(:downcase).strip }) do |row|
        attributes = row.to_hash.with_indifferent_access
        attributes = csv_params(attributes)

        if team = @teams.detect{ |t| t.name == attributes[:name] }
          next if ignore
          team.update_attributes!(attributes)
        else
          @tournament.teams.create!(attributes)
        end
      end
    end

    redirect_to action: :index

  rescue => e
    redirect_to action: :index, error: e
  end

  private

  def team_params
    @team_params ||= params.require(:team).permit(
      :id,
      :name,
      :email,
      :sms,
      :division,
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
