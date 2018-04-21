CheckPinMutation = GraphQL::Relay::Mutation.define do
  name "CheckPin"
  input_field :pin, types.String

  return_field :success, !types.Boolean
  return_field :errors, types[types.String]

  resolve -> (obj, args, ctx) {
    valid = args[:pin] == ctx[:tournament].score_submit_pin

    if valid
      { success: true }
    else
      { success: false, errors: ['Incorrect pin'] }
    end
  }
end
