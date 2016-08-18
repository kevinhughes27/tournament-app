class TeamUpdate < ComposableOperations::Operation
  processes :team, :params, :confirm

  property :team, accepts: Team, required: true
  property :params, required: true
  property :confirm, default: false

  def execute
    team.assign_attributes(params)

    unless team.update_safe?
      halt 'unable_to_update' if !team.allow_change?
      halt 'confirm_update' if !(confirm == 'true' || team.safe_to_change?)
    end

    team.update(params)
    fail if team.errors.present?
  end

  def confirmation_required?
    halted? && message == 'confirm_update'
  end
end
