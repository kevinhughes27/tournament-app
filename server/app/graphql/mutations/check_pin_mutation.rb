CheckPinMutation = GraphQL::Relay::Mutation.define do
  name "CheckPin"
  input_field :pin, types.String
  return_field :valid, !types.Boolean

  resolve -> (obj, args, ctx) {
    valid = args[:pin] == ctx[:tournament].score_submit_pin
    return { valid: valid }
  }
end
