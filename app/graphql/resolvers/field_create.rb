class Resolvers::FieldCreate < Resolver
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
        errors: field.errors.full_messages,
        field: field
      }
    end
  end
end
