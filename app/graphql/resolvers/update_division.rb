class Resolvers::UpdateDivision < Resolvers::BaseResolver
  def call(inputs, ctx)
    @tournament = ctx[:tournament]
    @division = @tournament.divisions.find(inputs[:division_id])
    params = inputs.to_h.except(:division_id, :confirm)

    @division.assign_attributes(params)
    bracket_type_changed = @division.bracket_type_changed?

    if !(inputs[:confirm] || @division.safe_to_change?)
      return {
        success: false,
        confirm: true,
        division: @division,
        message: @division.change_message
      }
    end

    if @division.update(params)
      update_bracket if bracket_type_changed
      {
        success: true,
        division: @division
      }
    else
      {
        success: false,
        division: @division,
        user_errors: @division.fields_errors
      }
    end
  end

  private

  def update_bracket
    @division.update_column(:seeded, false)

    bracket = BracketDb.find(handle: @division.bracket_type)

    ChangeBracketJob.perform_now(
      tournament_id: @division.tournament_id,
      division_id: @division.id,
      new_template: bracket.template
    )
  end
end
