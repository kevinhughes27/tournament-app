class TeamUpdate < MutationOperation
  input :team, accepts: Team
  input :params
  property :confirm, default: false

  def execute
    if update_unsafe?
      halt 'unable_to_update' if !team.allow_change?
      halt 'confirm_update' if !(confirm == 'true' || team.safe_to_change?)
    end

    team.update(params)
    halt 'failed' if team.errors.present?
  end

  def confirmation_required?
    halted? && @output == 'confirm_update'
  end

  def not_allowed?
    halted? && @output == 'unable_to_update'
  end

  private

  def update_unsafe?
    team.assign_attributes(params)
    team.division_id_changed? || team.seed_changed?
  end
end