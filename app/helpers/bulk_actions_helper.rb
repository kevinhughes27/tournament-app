module BulkActionsHelper
  def add_to_division_actions(tournament)
    tournament.divisions.map do |division|
      {
        text: "Add to #{division.name} Division",
        action_class: 'set_teams_division',
        arg: division.name,
        success_msg: "Teams added to #{division.name} Division",
        failure_msg: 'Error updating teams'
      }
    end
  end
end
