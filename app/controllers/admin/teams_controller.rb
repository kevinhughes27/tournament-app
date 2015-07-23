class Admin::TeamsController < AdminController

  def index
    @teams = @tournament.teams
    @teams = [@tournament.teams.build] if @teams.blank?
  end

  def create
    @teams = Team.update_set(@tournament.teams, teams_params)
    @teams = [@tournament.teams.build] if @teams.blank?
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
      :division,
      :seed,
      :wins,
      :points_for
    ])
    @teams_params[:teams] ||= []
    @teams_params[:teams].each{ |t| t[1][:tournament_id] = @tournament.id }
  end
end
