class Mutations::CreateDivision < Mutations::BaseMutation
  graphql_name "CreateDivision"

  argument :input, Inputs::CreateDivisionInput, required: true

  field :division, Types::Division, null: false
  field :success, Boolean, null: false
  field :userErrors, [Types::Error], null: true
end
