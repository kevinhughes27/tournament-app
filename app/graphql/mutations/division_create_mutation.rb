DivisionCreateMutation = GraphQL::Relay::Mutation.define do
  name "DivisionCreate"

  input_field :name, types.String
  input_field :num_teams, types.Int
  input_field :num_days, types.Int
  input_field :bracket_type, types.String

  return_field :success, !types.Boolean

  resolve(Auth.protect -> (obj, inputs, ctx) {
    op = DivisionCreate.new(
      tournament: ctx[:tournament],
      division_params: inputs.to_h
    )

    op.perform

    if op.succeeded?
      { success: true }
    else
      { success: false }
    end
  })
end
