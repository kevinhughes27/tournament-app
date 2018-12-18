class Resolvers::UpdateTeam < Resolvers::BaseResolver
  def call(inputs, ctx)
    team = ctx[:tournament].teams.find(inputs[:id])
    params = inputs.to_h.except(:team_id)

    if team.update(params)
      {
        success: true,
        message: 'Team updated',
        team: team
      }
    else
      {
        success: false,
        user_errors: team.fields_errors,
        team: team
      }
    end
  end
end
