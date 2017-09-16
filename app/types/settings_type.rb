SettingsType = GraphQL::ObjectType.define do
  name "Settings"
  description "Tournament Settings"
  field :protectScoreSubmit do
    type types.Boolean
    resolve -> (obj, args, ctx) {
      ctx[:tournament].score_submit_pin.present?
    }
  end
end
