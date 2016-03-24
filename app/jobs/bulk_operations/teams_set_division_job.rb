require 'render_anywhere'

class BulkOperations::TeamsSetDivisionJob < ActiveJob::Base
  include RenderAnywhere

  queue_as :default

  def perform(ids:, arg:)
    division = Division.find_by(name: arg)
    teams = Team.where(id: ids)
    teams.update_all(division_id: division.id)

    response = render_response(teams)
    response
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
