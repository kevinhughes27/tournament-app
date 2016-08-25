class DivisionDelete < ApplicationOperation
  processes :division, :confirm

  property :division, accepts: Division, required: true
  property :confirm, default: false

  def execute
    halt 'confirm_delete' if !(confirm == 'true' || division.safe_to_delete?)
    fail unless division.destroy
  end

  def confirmation_required?
    halted? && message == 'confirm_delete'
  end
end
