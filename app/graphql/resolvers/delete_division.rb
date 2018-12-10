class Resolvers::DeleteDivision < Resolvers::BaseResolver
  DIVISION_DELETE_CONFIRM_MSG = """This division has games that have been scored.\
 Deleting this division will delete all the games that belong to it.\
 Are you sure this is what you want to do?"""

  def call(inputs, ctx)
    division = ctx[:tournament].divisions.find(inputs[:id])

    if !(inputs[:confirm] || division.safe_to_delete?)
      {
        division: division,
        success: false,
        confirm: true,
        message: DIVISION_DELETE_CONFIRM_MSG
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
