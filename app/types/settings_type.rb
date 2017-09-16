SettingsType = GraphQL::ObjectType.define do
  name "Settings"
  description "Tournament Settings"
  field :protectScoreSubmit do
    type types.Boolean
    resolve -> (obj, args, ctx) {
      true
    }
  end
end
