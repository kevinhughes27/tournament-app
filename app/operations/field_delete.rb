class FieldDelete < ApplicationOperation
  processes :field, :confirm

  property :field, accepts: Field, required: true
  property :confirm, default: false

  def execute
    halt 'confirm_delete' if !(confirm == 'true' || field.safe_to_delete?)
    fail unless field.destroy
    un_schedule_games(field.id)
  end

  def confirmation_required?
    halted? && message == 'confirm_delete'
  end

  private

  def un_schedule_games(field_id)
    Game.where(field_id: field_id)
        .update_all(field_id: nil, start_time: nil)
  end
end
