class DivisionDelete < MutationOperation
  input :division, accepts: Division, required: true
  input :confirm, default: false, type: :keyword

  def execute
    halt 'confirm_delete' if !(confirm == 'true' || division.safe_to_delete?)
    division.destroy!
  end

  def confirmation_required?
    halted? && @output == 'confirm_delete'
  end
end
