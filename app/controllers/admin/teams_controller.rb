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
    @team = @tournament.teams.create(team_params)
    render :show
  end

  def update
    @team = @tournament.teams.find(params[:id])
    @team.update_attributes(team_params)
    render :show
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
end
