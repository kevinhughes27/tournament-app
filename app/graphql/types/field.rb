class Types::Field < Types::BaseObject
  graphql_name "Field"
  description "A Field"

  field :id, ID, null: true
  field :name, String, null: true
  field :lat, Float, null: true
  field :long, Float, null: true
  field :geoJson, String, null: true
end
