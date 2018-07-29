class Mutations::CreateDivision < Mutations::BaseMutation
  graphql_name "CreateDivision"

  argument :input, Inputs::CreateDivisionInput, required: true

  field :division, Types::Division, null: true
  field :success, Boolean, null: false
  field :message, String, null: true
  field :userErrors, [Types::Error], null: true
end
