DivisionCreateMutation = GraphQL::Relay::Mutation.define do
  name "DivisionCreate"

  input_field :name, types.String
  input_field :num_teams, types.Int
  input_field :num_days, types.Int
  input_field :bracket_type, types.String

  return_field :success, !types.Boolean
  return_field :errors, types[types.String]
  return_field :division, DivisionType

  resolve(Auth.protect -> (obj, inputs, ctx) {
    op = DivisionCreate.new(
      tournament: ctx[:tournament],
      division_params: inputs.to_h
    )

    op.perform

    division = op.division

    if op.succeeded?
      {
        success: true,
        division: division
      }
    else
      {
        success: false,
        errors: division.errors.full_messages,
        division: division
      }
    end
  })
end
