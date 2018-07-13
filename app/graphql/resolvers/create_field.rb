class Resolvers::CreateField < Resolvers::BaseResolver
  def call(inputs, ctx)
    params = inputs.to_h
    field = ctx[:tournament].fields.create(params)

    if field.persisted?
      {
        success: true,
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
