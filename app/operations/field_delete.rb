class FieldDelete < ApplicationOperation
  input :field, accepts: Field, required: true
  input :confirm, default: false

  def execute
    raise ConfirmationRequired if !(confirm == 'true' || field.safe_to_delete?)
    fail unless field.destroy
    unschedule_games(field.id)
  end

  private

  def unschedule_games(field_id)
    Game.where(field_id: field_id).update_all(field_id: nil, start_time: nil)
  end
end
