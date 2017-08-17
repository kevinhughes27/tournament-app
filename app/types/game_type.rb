GameType = GraphQL::ObjectType.define do
  name "Game"
  description "A Game"
  field :id, types.ID
  field :home_name, types.String
  field :away_name, types.String
  field :start_time, types.String
  field :end_time, types.String
  field :field_name, types.String
end
