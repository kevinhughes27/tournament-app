class DivisionUpdate < ComposableOperations::Operation
  processes :division, :params, :confirm

  property :division, accepts: Division, required: true
  property :params, required: true
  property :confirm, default: false

  def execute
    division.assign_attributes(params)

    halt 'confirm_update' if !(confirm == 'true' || division.safe_to_change?)

    division.update(params)
    fail if division.errors.present?
  end

  def confirmation_required?
    halted? && message == 'confirm_update'
  end
end
