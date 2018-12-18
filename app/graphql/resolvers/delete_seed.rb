class Resolvers::DeleteSeed < Resolvers::BaseResolver
  SEED_DELETE_CONFIRM_MSG = """This division has already been seeded. \
 Changing seeds will require a re-seed to take affect.\
 Re-seeding will reset any scored games."""

  def call(inputs, ctx)
    tournament = ctx[:tournament]
    division = tournament.divisions.find(inputs[:division_id])
    seed = division.seeds.find_by(team_id: inputs[:team_id], rank: inputs[:rank])

    if division.seeded && !inputs[:confirm]
      {
        division: division,
        success: false,
        confirm: true,
        message: SEED_DELETE_CONFIRM_MSG
      }
    elsif seed.destroy
      {
        division: division,
        success: true,
        message: 'Seed deleted'
      }
    else
      {
        division: division,
        success: false,
        message: 'Seed delete failed'
      }
    end
  end
end
