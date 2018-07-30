class Resolvers::CreateTeam < Resolvers::BaseResolver
  def call(inputs, ctx)
    params = inputs.to_h
    team = ctx[:tournament].teams.create(params)

    if team.persisted?
      {
        success: true,
        message: 'Team created',
        team: team,
      }
    else
      {
        success: false,
        user_errors: team.fields_errors,
      }
    end
  end
end
