json.extract! team,
  :id,
  :name,
  :email,
  :phone,
  :seed

json.path "teams/#{team.id}"
json.division team.division.try(:name)
