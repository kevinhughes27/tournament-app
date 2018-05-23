class Types::Field < Types::BaseObject
  graphql_name "Field"
  description "A Field"

  field :id, ID, null: false
  field :name, String, null: false
  field :lat, Float, null: true
  field :long, Float, null: true
  field :geoJson, String, null: true
end
