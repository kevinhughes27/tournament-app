class Resolvers::FieldUpdate < Resolver
  def call(inputs, ctx)
    field = ctx[:tournament].fields.find(inputs[:field_id])

    params = inputs.to_h.except('field_id')

    if field.update(params)
      {
        success: true,
        field: field
      }
    else
      {
        success: false,
        errors: field.errors.full_messages,
        field: field
      }
    end
  end
end
