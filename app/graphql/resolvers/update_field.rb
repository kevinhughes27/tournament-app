class Resolvers::UpdateField < Resolvers::BaseResolver
  def call(inputs, ctx)
    field = ctx[:tournament].fields.find(inputs[:field_id])

    params = inputs.to_h.except(:field_id)

    if field.update(params)
      {
        success: true,
        message: 'Field updated',
        field: field
      }
    else
      {
        success: false,
        user_errors: field.fields_errors,
        field: field
      }
    end
  end
end
