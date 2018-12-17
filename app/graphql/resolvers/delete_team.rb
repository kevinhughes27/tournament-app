class Resolvers::DeleteTeam < Resolvers::BaseResolver
  TEAM_DELETE_NOT_ALLOWED = """There are games scheduled for this team\
 In order to delete this team you need to delete the\
 division_name division first."""

  def call(inputs, ctx)
    team = ctx[:tournament].teams.find(inputs[:id])

    if !team.allow_delete?
      return {
        team: team,
        success: false,
        message: TEAM_DELETE_NOT_ALLOWED.gsub('division_name', team.division.name)
      }
    else if team.destroy
      {
        team: team,
        success: true,
        message: 'Team deleted'
      }
    else
      {
        team: team,
        success: false,
        message: 'Delete failed'
      }
    end
  end
end
