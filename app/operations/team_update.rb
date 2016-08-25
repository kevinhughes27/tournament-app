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
    (params[:division_id] && team.division_id != params[:division_id].to_i) ||
    (params[:seed] && team.seed != params[:seed].to_i)
  end
end
