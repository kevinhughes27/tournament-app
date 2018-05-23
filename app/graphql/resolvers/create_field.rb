class Resolvers::CreateField < Resolver
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
        user_errors: field.errors.full_messages,
        field: field
      }
    end
  end
end
