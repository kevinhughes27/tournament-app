class TeamUpdate < ApplicationOperation
  input :team, accepts: Team, required: true
  input :params, required: true
  input :confirm, default: false

  class UnableToUpdate < StandardError
  end

  def execute
    if update_unsafe?
      raise UnableToUpdate if !team.allow_change?
      raise ConfirmationRequired if !(confirm == 'true' || team.safe_to_change?)
    end

    team.update(params)
    fail if team.errors.present?
  end

  private

  def update_unsafe?
    team.assign_attributes(params)
    team.division_id_changed? || team.seed_changed?
  end
end
