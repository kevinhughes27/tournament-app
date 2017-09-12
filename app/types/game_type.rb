GameType = GraphQL::ObjectType.define do
  name "Game"
  description "A Game"
  field :id, types.ID
  field :home_name, types.String
  field :away_name, types.String
  field :field_name, types.String
  field :start_time, types.String do
    resolve ->(obj, args, ctx) {
      obj.start_time.rfc2822
    }
  end
  field :end_time, types.String do
    resolve ->(obj, args, ctx) {
      obj.end_time.rfc2822
    }
  end
  field :home_score, types.Int
  field :away_score, types.Int
  field :score_confirmed, types.Boolean
end
