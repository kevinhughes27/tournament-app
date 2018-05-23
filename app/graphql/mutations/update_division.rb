class Mutations::UpdateDivision < Mutations::BaseMutation
  graphql_name "UpdateDivision"

  argument :input, Types::UpdateDivisionInput, required: true

  field :success, Boolean, null: false
  field :confirm, Boolean, null: true
  field :userErrors, [String], null: true
  field :division, Types::Division, null: false
end
