TeamType = GraphQL::ObjectType.define do
  name "Team"
  description "A Team"
  field :id, types.ID
  field :name, types.String
  field :email, types.String, auth_required: true
  field :phone, types.String, auth_required: true
  field :division_id, types.ID
  field :seed, types.Int
end
