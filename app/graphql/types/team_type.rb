TeamType = GraphQL::ObjectType.define do
  name "Team"
  description "A Team"
  field :id, types.ID
  field :name, types.String
  field :email, types.String
  field :phone, types.String
  field :division_id, types.ID
  field :seed, types.Int
end
