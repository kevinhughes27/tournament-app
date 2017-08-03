class DivisionUpdate < ApplicationOperation
  input :division, accepts: Division, required: true
  input :params, required: true
  property :confirm, default: false

  class Failed < StandardError
    attr_reader :division

    def initialize(division, *args)
      @division = division
      super('DivisionCreate failed.', *args)
    end
  end

  def execute
    division.assign_attributes(params)
    bracket_type_changed = division.bracket_type_changed?

    raise ConfirmationRequired if !(confirm == 'true' || division.safe_to_change?)

    division.update(params)
    raise Failed(division) if division.errors.present?

    update_bracket if bracket_type_changed
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
