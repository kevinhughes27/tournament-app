CheckPinMutation = GraphQL::Relay::Mutation.define do
  name "CheckPin"
  input_field :pin, types.String
  return_field :valid, !types.Boolean

  resolve -> (obj, args, ctx) {
    return { valid: args[:pin] == '1234' }
  }
end
