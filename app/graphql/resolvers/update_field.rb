class Resolvers::UpdateField < Resolvers::BaseResolver
  def call(inputs, ctx)
    id = database_id(inputs[:id])

    field = ctx[:tournament].fields.find(id)

    params = inputs.to_h.except(:id)

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
