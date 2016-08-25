class TeamDelete < ApplicationOperation
  processes :team, :confirm

  property :team, accepts: Team, required: true
  property :confirm, default: false

  def execute
    halt 'unable_to_delete' if !team.allow_delete?
    halt 'confirm_delete' if !(confirm == 'true' || team.safe_to_delete?)
    fail unless team.destroy
  end

  def confirmation_required?
    halted? && message == 'confirm_delete'
  end
end
