class Types::Field < Types::BaseObject
  graphql_name "Field"
  description "A Field"

  global_id_field :id

  field :name, String, null: false
  field :lat, Float, null: false
  field :long, Float, null: false
  field :geoJson, String, null: false
end
