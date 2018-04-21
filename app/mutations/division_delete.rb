class DivisionDelete < ApplicationOperation
  input :division, accepts: Division, required: true
  input :confirm, accepts: [true, false], default: false, type: :keyword

  def execute
    halt 'confirm_delete' if !(confirm || division.safe_to_delete?)
    division.destroy!
  end

  def confirmation_required?
    halted? && @output == 'confirm_delete'
  end
end
