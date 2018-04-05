module TeamsHelper
  def division_options(tournament, team)
    options = tournament.divisions.collect{ |division|
      [division.name, division.id]
    }

    unless team.division_id
      options.unshift(['Select a division', nil])
    end

    options_for_select(options, team.division_id)
  end

  def set_division_actions(tournament)
    tournament.divisions.map do |division|
      {
        text: "Add to #{division.name} Division",
        url: 'teams/set_division',
        arg: division.name,
        success_msg: "Teams added to #{division.name} Division",
        failure_msg: 'Error updating teams'
      }
    end
  end
end
