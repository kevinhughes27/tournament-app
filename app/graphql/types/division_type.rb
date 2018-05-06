DivisionType = GraphQL::ObjectType.define do
  name "Division"
  description "A Division"
  field :id, types.ID
  field :name, types.String
  field :num_teams, types.Int
  field :num_days, types.Int
  field :bracket_type, types.String
end
