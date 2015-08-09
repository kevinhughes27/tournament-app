class Admin::SeedingController < AdminController

  def index
    @teams = @tournament.teams
  end

  def update
    @teams = Team.update_set(@tournament.teams, teams_params)
    render :index
  end

  private

  def teams_params
    @teams_params ||= params.permit(teams: [
      :id,
      :seed,
      :wins,
      :points_for
    ])
    @teams_params[:teams] ||= []
    @teams_params[:teams].each{ |t| t[1][:tournament_id] = @tournament.id }
  end
end
