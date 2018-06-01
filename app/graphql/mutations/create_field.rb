class Mutations::CreateField < Mutations::BaseMutation
  graphql_name "CreateField"

  argument :input, Inputs::CreateFieldInput, required: true

  field :success, Boolean, null: false
  field :userErrors, [String], null: true
  field :field, Types::Field, null: false
end
