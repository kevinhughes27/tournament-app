class Resolvers::DeleteDivision < Resolver
  DIVISION_DELETE_CONFIRM_MSG = """This division has games that have been scored.\
 Deleting this division will delete all the games that belong to it.\
 Are you sure this is what you want to do?"""

  def call(inputs, ctx)
    division = ctx[:tournament].divisions.find(inputs[:division_id])

    if !(inputs[:confirm] || division.safe_to_delete?)
      {
        success: false,
        confirm: true,
        errors: [DIVISION_DELETE_CONFIRM_MSG]
      }
    elsif division.destroy
      { success: true }
    else
      {
        success: false,
        errors: division.errors.full_messages
      }
    end
  end
end
