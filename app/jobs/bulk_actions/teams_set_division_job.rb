require 'render_anywhere'

class BulkActions::TeamsSetDivisionJob < ActiveJob::Base
  include RenderAnywhere

  queue_as :default

  def perform(ids:, arg:)
    division = Division.find_by(name: arg)
    teams = Team.where(id: ids)

    if teams.all? {|t| t.safe_to_change? }
      teams.update_all(division_id: division.id)
      response = render_response(teams)
      status = 200
    else
      response = {message: 'Cancelled: not all teams could be update safely'}
      status = 422
    end

    return response, status
  end

  private

  def render_response(teams)
    render(
      template: 'admin/teams/teams.json.jbuilder',
      layout: false,
      locals: {teams: teams}
    )
  end
end
