class UpdateSettings < ApplicationOperation
  processes :tournament, :params, :confirm

  property :tournament, accepts: Tournament, required: true
  property :params, required: true
  property :confirm, default: false

  def execute
    if !(confirm == 'true' || tournament.handle == params[:handle])
      tournament.assign_attributes(params)
      halt 'confirm_update'
    end

    tournament.update(params)
    fail if tournament.errors.present?
  end

  def confirmation_required?
    halted? && message == 'confirm_update'
  end
end
