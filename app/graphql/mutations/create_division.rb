class Mutations::CreateDivision < Mutations::BaseMutation
  graphql_name "CreateDivision"

  argument :input, Inputs::CreateDivisionInput, required: true

  field :success, Boolean, null: false
  field :userErrors, [String], null: true
  field :division, Types::Division, null: false
end
