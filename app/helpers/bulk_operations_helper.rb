module BulkOperationsHelper
  def add_to_division_operations(tournament)
    tournament.divisions.map do |division|
      {
        text: "Add to #{division.name} Division",
        job: 'teams_set_division',
        arg: division.name,
        success_msg: "Teams added to #{division.name} Division",
        failure_msg: 'Error updating teams'
      }
    end
  end
end
