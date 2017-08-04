class TeamDelete < ApplicationOperation
  input :team, accepts: Team, required: true
  input :confirm, default: false

  class UnableToDelete < StandardError
  end

  def execute
    halt 'unable_to_delete' if !team.allow_delete?
    raise ConfirmationRequired if !(confirm == 'true' || team.safe_to_delete?)
    fail unless team.destroy
  end

  def confirmation_required?
    halted? && message == 'confirm_delete'
  end
end
