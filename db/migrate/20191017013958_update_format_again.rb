class UpdateFormatAgain < ActiveRecord::Migration[5.2]
  def change
    bracket = BracketDb.find(handle: "CUUC Open 2019 Div II")

    Division.where(bracket_type: "CUUC Open 2019 Div II").find_each do |division|
      ChangeBracketJob.perform_now(
        tournament_id: division.tournament_id,
        division_id: division.id,
        new_template: bracket.template
      )
    end
  end
end
