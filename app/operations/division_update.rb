class DivisionUpdate < ApplicationOperation
  processes :division, :params, :confirm

  property :division, accepts: Division, required: true
  property :params, required: true
  property :confirm, default: false

  def execute
    division.assign_attributes(params)
    bracket_type_changed = division.bracket_type_changed?

    halt 'confirm_update' if !(confirm == 'true' || division.safe_to_change?)

    division.update(params)
    fail if division.errors.present?

    update_bracket if bracket_type_changed
  end

  def confirmation_required?
    halted? && message == 'confirm_update'
  end

  private

  def update_bracket
    division.update_column(:seeded, false)

    bracket = Bracket.find_by(handle: division.bracket_type)

    ChangeBracketJob.perform_later(
      tournament_id: division.tournament_id,
      division_id: division.id,
      new_template: bracket.template
    )
  end
end
