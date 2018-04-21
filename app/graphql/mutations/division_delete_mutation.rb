DivisionDeleteMutation = GraphQL::Relay::Mutation.define do
  name "DivisionDelete"

  input_field :division_id, types.ID
  input_field :confirm, types.Boolean

  return_field :success, !types.Boolean
  return_field :confirm, types.Boolean
  return_field :errors, types[types.String]

  resolve(Auth.protect -> (obj, inputs, ctx) {
    division = ctx[:tournament].divisions.find(inputs[:division_id])

    op = DivisionDelete.new(division, confirm: inputs[:confirm])

    op.perform

    if op.succeeded?
      { success: true }
    elsif op.confirmation_required?
      {
        success: false,
        confirm: true,
        errors: ["This division has games that have been scored. Deleting this division will delete all the games that belong to it. Are you sure this is what you want to do?"]
      }
    else
      { success: false, errors: [op.output] }
    end
  })
end
