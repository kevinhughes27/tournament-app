class Types::Field < Types::BaseObject
  graphql_name "Field"
  description "A Field"

  global_id_field :id
  field :name, String, null: true
  field :lat, Float, null: true
  field :long, Float, null: true
  field :geoJson, String, null: true
end
