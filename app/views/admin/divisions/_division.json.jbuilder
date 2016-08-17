json.extract! division,
  :id,
  :name,
  :num_teams

json.path "divisions/#{division.id}"
json.teams_count division.teams.count
json.bracket division.bracket_type
json.seeded division.seeded?
json.dirty_seed division.dirty_seed?
