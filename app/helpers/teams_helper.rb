module TeamsHelper
  def division_options(tournament, team)
    options = tournament.divisions.collect{ |division|
      [division.name, division.id]
    }

    unless team.division_id
      options.unshift(['Select a bracket', nil])
    end

    options_for_select(options, team.division_id)
  end
end
