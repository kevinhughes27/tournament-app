class TeamDelete < MutationOperation
  input :team, accepts: Team
  property :confirm, default: false

  def execute
    halt 'unable_to_delete' if !team.allow_delete?
    halt 'confirm_delete' if !(confirm == 'true' || team.safe_to_delete?)
    team.destroy!
  end

  def confirmation_required?
    halted? && @output == 'confirm_delete'
  end
end
