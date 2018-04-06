DivisionSeedMutation = GraphQL::Relay::Mutation.define do
  name "DivisionSeed"

  input_field :division_id, types.ID
  input_field :team_ids, types[types.ID]
  input_field :seeds, types[types.Int]
  input_field :confirm, types.Boolean

  return_field :success, !types.Boolean

  resolve(Auth.protect -> (obj, inputs, ctx) {
    division = ctx[:tournament].divisions.find(inputs[:division_id])

    op = DivisionSeed.new(
      division: division,
      team_ids: inputs[:team_ids],
      seeds: inputs[:seeds],
      confirm: inputs[:confirm]
    )

    op.perform

    if op.succeeded?
      { success: true }
    elsif op.confirmation_required?
      { success: false }
    else
      { success: false }
    end
  })
end
