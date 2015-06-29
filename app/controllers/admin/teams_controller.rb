class Admin::TeamsController < AdminController

  def index
    @teams = Team.all
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to @team, notice: 'Team was successfully created.'
    else
      render :new
    end
  end

  private

  def teams_params
    @teams_params ||= params.permit(
      teams: [
        :id,
        :name,
        :email,
        :sms,
        :twitter,
        :division
      ]
    )
  end
end
