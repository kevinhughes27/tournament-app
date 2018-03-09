class UpdatePp16 < ActiveRecord::Migration[5.0]
  def change
    Division.where(bracket_type: 'Power Pools 16').each do |division|
      Divisions::ChangeBracketJob.perform_later(
        tournament_id: division.tournament_id,
        division_id: division.id,
        new_template: division.bracket.template
      )
    end
  end
end
