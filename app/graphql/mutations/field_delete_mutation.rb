FieldDeleteMutation = GraphQL::Relay::Mutation.define do
  name "FieldDelete"

  input_field :field_id, types.ID
  input_field :confirm, types.Boolean

  return_field :success, !types.Boolean

  resolve(Auth.protect -> (obj, inputs, ctx) {
    field = ctx[:tournament].fields.find(inputs[:field_id])

    op = FieldDelete.new(field, confirm: inputs[:confirm])

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
