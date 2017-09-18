TeamType = GraphQL::ObjectType.define do
  name "Team"
  description "A Team"
  field :id, types.ID
  field :name, types.String
end
