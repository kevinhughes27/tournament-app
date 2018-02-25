json.extract! field,
  :id,
  :name,
  :lat,
  :long

json.path "fields/#{field.id}"
json.geoJson field.geo_json
