class Resolvers::DeleteDivision < Resolvers::BaseResolver
  DIVISION_SCORED_MSG = """This division has games that have been scored.\
 Deleting this division will delete all the games that belong to it.\
 Are you sure this is what you want to do?"""

  DIVISION_SCHEDULED_MSG = """This division has games that have been scheduled.\
 Deleting this division will delete all the games that belong to it.\
 Are you sure this is what you want to do?"""

  DIVISION_SEEDED_MSG = """This division has been seeded.\
 Deleting this division will remove all the seeds that belong to it.\
 Are you sure this is what you want to do?"""

  def call(inputs, ctx)
    division = ctx[:tournament].divisions.find(inputs[:id])

    if !inputs[:confirm] && division.games.scored.exists?
      {
        division: division,
        success: false,
        confirm: true,
        message: DIVISION_SCORED_MSG
      }
    elsif !inputs[:confirm] && division.games.scheduled.exists?
      {
        division: division,
        success: false,
        confirm: true,
        message: DIVISION_SCHEDULED_MSG
      }
    elsif !inputs[:confirm] && division.seeded
      {
        division: division,
        success: false,
        confirm: true,
        message: DIVISION_SEEDED_MSG
      }
    elsif division.destroy
      {
        division: division,
        success: true,
        message: 'Division deleted'
      }
    else
      {
        division: division,
        success: false,
        user_errors: division.fields_errors
      }
    end
  end
end
