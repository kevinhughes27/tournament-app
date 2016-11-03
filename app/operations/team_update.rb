class TeamUpdate < ApplicationOperation
  processes :team, :params, :confirm

  property :team, accepts: Team, required: true
  property :params, required: true
  property :confirm, default: false

  def execute
    if update_unsafe?
      halt 'unable_to_update' if !team.allow_change?
      halt 'confirm_update' if !(confirm == 'true' || team.safe_to_change?)
    end

    team.update(params)
    fail if team.errors.present?
  end

  def confirmation_required?
    halted? && message == 'confirm_update'
  end

  private

  def update_unsafe?
    team.assign_attributes(params)
    team.division_id_changed? || team.seed_changed?
  end
end
