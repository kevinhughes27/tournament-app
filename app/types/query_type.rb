QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The root query for this schema"

  field :games do
    type types[GameType]
    resolve -> (obj, args, ctx) {
      ctx[:tournament].games
    }
  end

  field :fields do
    type types[FieldType]
    resolve -> (obj, args, ctx) {
      ctx[:tournament].fields
    }
  end
end
