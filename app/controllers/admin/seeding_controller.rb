class Admin::SeedingController < AdminController

  def index
    @teams = @tournament.teams
  end

  def update
    teams = Team.where(id: teams_params.map{ |p| p[:id] })

    teams.each do |team|
      attributes = teams_params.detect{ |p| p[:id] == "#{team.id}" }
      team.update_attributes( attributes )
    end

    @teams = @tournament.teams
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
    @teams_params[:teams] ||= {}
    @teams_params[:teams].values
  end
end
