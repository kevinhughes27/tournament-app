FieldType = GraphQL::ObjectType.define do
  name "Field"
  description "A Field"
  field :id, types.ID
  field :name, types.String
  field :lat, types.Float
  field :long, types.Float
  field :geo_json, types.String
end
