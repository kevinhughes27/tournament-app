MapType = GraphQL::ObjectType.define do
  name "Map"
  description "Tournament Map"
  field :lat, types.Float
  field :long, types.Float
  field :zoom, types.Int
end
