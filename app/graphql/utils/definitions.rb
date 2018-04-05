GraphQL::Field.accepts_definitions(
  auth_required: -> (field, _) {
    field.metadata[:visibility_proc] = -> (ctx) { Auth.visible(ctx) }
  }
)
