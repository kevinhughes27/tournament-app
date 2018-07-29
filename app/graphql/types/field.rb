class Types::Field < Types::BaseObject
  graphql_name "Field"
  description "A Field"

  field :id, ID, null: false
  field :name, String, null: false
  field :lat, Float, null: false
  field :long, Float, null: false
  field :geoJson, String, null: false
end
