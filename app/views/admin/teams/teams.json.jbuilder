json.teams(@teams) do |team|
  json.partial! 'admin/teams/team', team: team
end
