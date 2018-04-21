DivisionSeedMutation = GraphQL::Relay::Mutation.define do
  name "DivisionSeed"

  input_field :division_id, types.ID
  input_field :team_ids, types[types.ID]
  input_field :seeds, types[types.Int]
  input_field :confirm, types.Boolean

  return_field :success, !types.Boolean
  return_field :confirm, types.Boolean
  return_field :errors, types[types.String]

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
      {
        success: false,
        confirm: true,
        errors: ["This division has games that have been scored. Seeding this division will reset those games. Are you sure this is what you want to do?"]
      }
    else
      { success: false, errors: [op.output] }
    end
  })
end
