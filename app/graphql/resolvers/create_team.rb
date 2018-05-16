class Resolvers::CreateTeam < Resolver
  def call(inputs, ctx)
    params = inputs.to_h
    team = ctx[:tournament].teams.create(params)

    if team.persisted?
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
