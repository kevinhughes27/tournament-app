class Mutations::DeleteDivision < Mutations::BaseMutation
  graphql_name "DeleteDivision"

  argument :input, Inputs::DeleteDivisionInput, required: true

  field :division, Types::Division, null: false
  field :success, Boolean, null: false
  field :confirm, Boolean, null: true
  field :message, String, null: true
  field :userErrors, [Types::Error], null: true
end
