class Mutations::UpdateField < Mutations::BaseMutation
  graphql_name "UpdateField"

  argument :input, Inputs::UpdateFieldInput, required: true

  field :success, Boolean, null: false
  field :userErrors, [String], null: true
  field :field, Types::Field, null: false
end
