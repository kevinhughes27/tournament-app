QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The root query for this schema"

  field :settings do
    type SettingsType
    resolve -> (obj, args, ctx) {
      ctx[:tournament]
    }
  end

  field :map do
    type MapType
    resolve -> (obj, args, ctx) {
      ctx[:tournament].map
    }
  end

  field :fields do
    type types[FieldType]
    resolve -> (obj, args, ctx) {
      ctx[:tournament].fields
    }
  end

  field :teams do
    type types[TeamType]
    resolve -> (obj, args, ctx) {
      ctx[:tournament].teams
    }
  end

  field :divisions do
    type types[DivisionType]
    resolve -> (obj, args, ctx) {
      ctx[:tournament].divisions
    }
  end

  field :games do
    type types[GameType]
    resolve -> (obj, args, ctx) {
      ctx[:tournament].games
        .scheduled
        .with_team
        .includes(:home, :away, :field)
    }
  end
end
