class Mutations::SeedDivision < Mutations::BaseMutation
  graphql_name "SeedDivision"

  argument :input, Inputs::SeedDivisionInput, required: true

  field :success, Boolean, null: false
  field :confirm, Boolean, null: true
  field :message, String, null: true
end
