GraphQL::Field.accepts_definitions(
  visibility: -> (field, visibility_proc) {
    field.metadata[:visibility_proc] = visibility_proc
  }
)
