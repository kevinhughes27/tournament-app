class Resolvers::UpdateTeam < Resolver
  TEAM_UPDATE_CONFIRM_MSG = """There are games scheduled for this team.\
 Updating the team may unassign it from those games.\
 You will need to re-seed the division_name division."""

  TEAM_UPDATE_NOT_ALLOWED = """There are games in this team's division that have been scored.\
 In order to update this team you need to delete\
 the division_name division first."""

  def call(inputs, ctx)
    team = ctx[:tournament].teams.find(inputs[:team_id])
    params = inputs.to_h.except('team_id', 'confirm')

    team.assign_attributes(params)
    update_unsafe = team.division_id_changed? || team.seed_changed?

    if update_unsafe
      if !team.allow_change?
        return {
          success: false,
          not_allowed: true,
          errors: [TEAM_UPDATE_NOT_ALLOWED.gsub('division_name', team.division.name)],
          team: team
        }
      end

      if !(inputs[:confirm] || team.safe_to_change?)
        return {
          success: false,
          confirm: true,
          errors: [TEAM_UPDATE_CONFIRM_MSG.gsub('division_name', team.division.name)],
          team: team
        }
      end
    end

    if team.update(params)
      {
        success: true,
        team: team
      }
    else
      {
        success: false,
        errors: team.errors.full_messages,
        team: team
      }
    end
  end
end
