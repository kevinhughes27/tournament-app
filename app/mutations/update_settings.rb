class UpdateSettings < MutationOperation
  property! :tournament, accepts: Tournament
  property! :params
  property :confirm, default: false

  def execute
    if !(confirm == 'true' || tournament.handle == params[:handle])
      tournament.assign_attributes(params)
      halt 'confirm_update'
    end

    tournament.update(params)
    halt if tournament.errors.present?
  end

  def confirmation_required?
    halted? && @output == 'confirm_update'
  end
end
