FieldDeleteMutation = GraphQL::Relay::Mutation.define do
  name "FieldDelete"

  input_field :field_id, types.ID
  input_field :confirm, types.Boolean

  return_field :success, !types.Boolean
  return_field :confirm, types.Boolean
  return_field :errors, types[types.String]

  resolve(Auth.protect -> (obj, inputs, ctx) {
    field = ctx[:tournament].fields.find(inputs[:field_id])

    op = FieldDelete.new(field, confirm: inputs[:confirm])

    op.perform

    if op.succeeded?
      { success: true }
    elsif op.confirmation_required?
      {
        success: false,
        confirm: true,
        errors: ["There are games scheduled on this field. Deleting will leave these games unassigned. You can re-assign them on the schedule page however if your Tournament is in progress this is probably not something you want to do."]
      }
    else
      { success: false }
    end
  })
end
