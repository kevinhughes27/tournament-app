DivisionDeleteMutation = GraphQL::Relay::Mutation.define do
  name "DivisionDelete"

  input_field :division_id, types.ID
  input_field :confirm, types.Boolean

  return_field :success, !types.Boolean

  resolve(Auth.protect -> (obj, inputs, ctx) {
    division = ctx[:tournament].divisions.find(inputs[:division_id])

    op = DivisionDelete.new(division, confirm: inputs[:confirm])

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
