class Resolvers::DeleteField < Resolvers::BaseResolver
  FIELD_DELETE_CONFIRM_MSG = """There are games scheduled on this field.\
 Deleting will leave these games unassigned.\
 You can re-assign them on the schedule page however if your Tournament\
 is in progress this is probably not something you want to do."""

  def call(inputs, ctx)
    @field = ctx[:tournament].fields.find(inputs[:id])

    if !(inputs[:confirm] || safe_to_delete?)
      {
        field: @field,
        success: false,
        confirm: true,
        message: FIELD_DELETE_CONFIRM_MSG
      }
    elsif delete
      {
        field: @field,
        success: true,
        message: 'Field deleted'
      }
    else
      {
        field: @field,
        success: false,
        message: 'Delete failed'
      }
    end
  end

  private

  def safe_to_delete?
    !Game.where(tournament_id: @field.tournament_id, field_id: @field.id).exists?
  end

  def delete
    Field.transaction do
      @field.destroy!
      unschedule_games
    end
  end

  def unschedule_games
    Game.where(field_id: @field.id).update_all(field_id: nil, start_time: nil, end_time: nil)
  end
end
