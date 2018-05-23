class Mutations::UpdateSettings < Mutations::BaseMutation
  graphql_name "UpdateSettings"

  argument :input, Types::UpdateSettingsInput, required: true

  field :success, Boolean, null: false
  field :confirm, Boolean, null: true
  field :userErrors, [String], null: true
end
