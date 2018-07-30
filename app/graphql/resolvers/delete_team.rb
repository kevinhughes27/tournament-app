class Resolvers::DeleteTeam < Resolvers::BaseResolver
  TEAM_DELETE_CONFIRM_MSG = """There are games scheduled for this team.\
 Deleting the team will unassign it from those games.\
 You will need to re-seed the division_name division."""

  TEAM_DELETE_NOT_ALLOWED = """There are games in this team's division that have been scored.\
 In order to delete this team you need to delete the\
 division_name division first."""

  def call(inputs, ctx)
    team = ctx[:tournament].teams.find(inputs[:id])

    if !team.allow_delete?
      return {
        success: false,
        not_allowed: true,
        message: TEAM_DELETE_NOT_ALLOWED.gsub('division_name', team.division.name)
      }
    end

    if !(inputs[:confirm] || team.safe_to_delete?)
      return {
        success: false,
        confirm: true,
        message: TEAM_DELETE_CONFIRM_MSG.gsub('division_name', team.division.name)
      }
    end

    if team.destroy
      {
        success: true,
        message: 'Team deleted'
      }
    else
      {
        success: false,
        message: 'Delete failed'
      }
    end
  end

  def confirmation_required?
    halted? && @output == 'confirm_delete'
  end
end
