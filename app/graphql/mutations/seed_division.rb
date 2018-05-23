class Mutations::SeedDivision < Mutations::BaseMutation
  graphql_name "SeedDivision"

  argument :input, Types::SeedDivisionInput, required: true

  field :success, Boolean, null: false
  field :confirm, Boolean, null: true
  field :userErrors, [String], null: true
end
