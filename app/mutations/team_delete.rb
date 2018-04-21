class TeamDelete < ApplicationOperation
  input :team, accepts: Team, required: true
  input :confirm, accepts: [true, false], default: false, type: :keyword

  def execute
    halt 'unable_to_delete' if !team.allow_delete?
    halt 'confirm_delete' if !(confirm || team.safe_to_delete?)
    team.destroy!
  end

  def confirmation_required?
    halted? && @output == 'confirm_delete'
  end
end
