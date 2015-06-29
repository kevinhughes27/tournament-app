class Admin::TeamsController < AdminController

  def index
    @teams = @tournament.teams
  end

  def create
    @teams = Team.update_set(@tournament.teams, teams_params)
    render :index
  end

  private

  def teams_params
    @teams_params ||= params.permit(teams: [
      :id,
      :name,
      :email,
      :sms,
      :twitter,
      :division
    ])

    @teams_params[:teams] || []
  end
end
