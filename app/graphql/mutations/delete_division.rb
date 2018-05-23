class Mutations::DeleteDivision < Mutations::BaseMutation
  graphql_name "DeleteDivision"

  argument :input, Types::DeleteDivisionInput, required: true

  field :success, Boolean, null: false
  field :confirm, Boolean, null: true
  field :userErrors, [String], null: true
end
