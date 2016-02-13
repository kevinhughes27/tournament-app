module TeamsHelper
  def division_options(tournament, team)
    options_for_select(tournament.divisions.collect{ |division|
      [division.name, division.id]
    }, team.division_id)
  end
end
