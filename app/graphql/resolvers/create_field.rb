class Resolvers::CreateField < Resolvers::BaseResolver
  def call(inputs, ctx)
    params = inputs.to_h
    field = ctx[:tournament].fields.create(params)

    if field.persisted?
      {
        success: true,
        message: 'Field created',
        field: field
      }
    else
      {
        success: false,
        user_errors: field.fields_errors,
      }
    end
  end
end
