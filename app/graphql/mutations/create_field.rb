class Mutations::CreateField < Mutations::BaseMutation
  graphql_name "CreateField"

  argument :input, Inputs::CreateFieldInput, required: true

  field :field, Types::Field, null: false
  field :success, Boolean, null: false
  field :userErrors, [Types::Error], null: true
end
