class UpdateSettings < ApplicationOperation
  input :tournament, accepts: Tournament, required: true, type: :keyword
  input :params, required: true, type: :keyword
  input :confirm, accepts: [true, false], default: false, type: :keyword

  def execute
    if !(confirm || tournament.handle == params['handle'])
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
