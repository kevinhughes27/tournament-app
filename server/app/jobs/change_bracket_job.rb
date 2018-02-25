class ChangeBracketJob < ApplicationJob
  def perform(tournament_id:, division_id:, new_template:)
    ChangeBracket.perform(
      tournament_id: tournament_id,
      division_id: division_id,
      new_template: new_template
    )
  end
end
