class BulkActions::TeamsSetDivisionJob < ApplicationJob

  def perform(tournament_id:, ids:, arg:)
    division = Division.find_by(tournament_id: tournament_id, name: arg)
    teams = Team.where(id: ids)

    if teams.all? {|t| t.safe_to_change? }
      teams.update_all(division_id: division.id)
      teams.reload
      response = render_response(teams)
      status = 200
    else
      response = {message: 'Cancelled: not all teams could be updated safely'}
      status = 422
    end

    return response, status
  end

  private

  def render_response(teams)
    Admin::BulkActionsController.render(
      template: 'admin/teams/teams.json.jbuilder',
      layout: false,
      locals: {teams: teams}
    )
  end
end
