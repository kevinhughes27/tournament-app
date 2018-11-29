class Resolvers::DeleteField < Resolvers::BaseResolver
  FIELD_DELETE_CONFIRM_MSG = """There are games scheduled on this field.\
 Deleting will leave these games unassigned.\
 You can re-assign them on the schedule page however if your Tournament\
 is in progress this is probably not something you want to do."""

  def call(inputs, ctx)
    id = database_id(inputs[:id])
    field = ctx[:tournament].fields.find(id)

    if !(inputs[:confirm] || field.safe_to_delete?)
      return {
        success: false,
        confirm: true,
        message: FIELD_DELETE_CONFIRM_MSG
      }
    end

    deleted = Field.transaction do
      field.destroy!
      unschedule_games(field.id)
    end

    if deleted
      {
        success: true,
        message: 'Field deleted'
      }
    else
      {
        success: false,
        message: 'Delete failed'
      }
    end
  end

  private

  def unschedule_games(field_id)
    Game.where(field_id: field_id).update_all(field_id: nil, start_time: nil)
  end
end
