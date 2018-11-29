class Resolvers::DeleteDivision < Resolvers::BaseResolver
  DIVISION_DELETE_CONFIRM_MSG = """This division has games that have been scored.\
 Deleting this division will delete all the games that belong to it.\
 Are you sure this is what you want to do?"""

  def call(inputs, ctx)
    id = database_id(inputs[:id])
    division = ctx[:tournament].divisions.find(id)

    if !(inputs[:confirm] || division.safe_to_delete?)
      {
        success: false,
        confirm: true,
        message: DIVISION_DELETE_CONFIRM_MSG
      }
    elsif division.destroy
      {
        success: true,
        message: 'Division deleted'
      }
    else
      {
        success: false,
        user_errors: division.fields_errors
      }
    end
  end
end
