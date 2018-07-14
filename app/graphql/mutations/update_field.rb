class Mutations::UpdateField < Mutations::BaseMutation
  graphql_name "UpdateField"

  argument :input, Inputs::UpdateFieldInput, required: true

  field :field, Types::Field, null: false
  field :success, Boolean, null: false
  field :message, String, null: true
  field :userErrors, [Types::Error], null: true
end
