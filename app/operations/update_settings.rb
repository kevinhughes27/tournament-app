class UpdateSettings < ApplicationOperation
  input :tournament, accepts: Tournament, required: true
  input :params, required: true
  input :confirm, default: false

  def execute
    if !(confirm == 'true' || tournament.handle == params[:handle])
      tournament.assign_attributes(params)
      raise ConfirmationRequired
    end

    tournament.update(params)
    fail if tournament.errors.present?
  end
end
