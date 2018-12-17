class Resolvers::CreateSeed < Resolvers::BaseResolver
  def call(inputs, ctx)
    tournament = ctx[:tournament]
    division = tournament.divisions.find(inputs[:division_id])
    team = tournament.teams.find(inputs[:team_id])

    seed = Seed.create(
      tournament: tournament,
      division: division,
      team: team,
      rank: inputs[:rank]
    )

    if seed.persisted?
      {
        division: division,
        success: true,
        message: 'Seed created',
      }
    else
      {
        division: division,
        success: false,
        message: 'Seed create failed',
        user_errors: seed.fields_errors,
      }
    end
  end
end
