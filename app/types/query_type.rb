QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The root query for this schema"

  field :games do
    type types[GameType]
    resolve -> (obj, args, ctx) {
      ctx[:tournament].games
    }
  end
end
