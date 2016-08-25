class FieldDelete < ApplicationOperation
  processes :field, :confirm

  property :field, accepts: Field, required: true
  property :confirm, default: false

  def execute
    halt 'confirm_delete' if !(confirm == 'true' || field.safe_to_delete?)
    fail unless field.destroy
  end

  def confirmation_required?
    halted? && message == 'confirm_delete'
  end
end
