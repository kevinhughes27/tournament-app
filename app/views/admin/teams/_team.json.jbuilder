json.id team.id
json.path "teams/#{team.id}"
json.name team.name
json.email team.email
json.phone team.phone
json.division team.division.try(:name)
json.seed team.seed
