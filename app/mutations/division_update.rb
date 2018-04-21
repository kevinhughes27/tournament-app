class DivisionUpdate < ApplicationOperation
  input :division, accepts: Division, required: true
  input :params, required: true
  input :confirm, accepts: [true, false], default: false, type: :keyword

  def execute
    division.assign_attributes(params)
    bracket_type_changed = division.bracket_type_changed?

    halt 'confirm_update' if !(confirm || division.safe_to_change?)

    division.update!(params)

    update_bracket if bracket_type_changed
  end

  def confirmation_required?
    halted? && @output == 'confirm_update'
  end

  private

  def update_bracket
    division.update_column(:seeded, false)

    bracket = Bracket.find_by(handle: division.bracket_type)

    ChangeBracketJob.perform_now(
      tournament_id: division.tournament_id,
      division_id: division.id,
      new_template: bracket.template
    )
  end
end
