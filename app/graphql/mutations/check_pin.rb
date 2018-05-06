module Mutations
  CheckPin = GraphQL::Relay::Mutation.define do
    name "CheckPin"
    input_field :pin, types.String

    return_field :success, !types.Boolean
    return_field :errors, types[types.String]

    resolve -> (obj, inputs, ctx) {
      valid = (inputs[:pin] == ctx[:tournament].score_submit_pin)

      if valid
        { success: true }
      else
        { success: false, errors: ['Incorrect pin'] }
      end
    }
  end
end
