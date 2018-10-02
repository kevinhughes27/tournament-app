class Mutations::UpdateSettings < Mutations::BaseMutation
  graphql_name "UpdateSettings"

  argument :input, Inputs::UpdateSettingsInput, required: true

  field :settings, Types::Settings, null: false
  field :success, Boolean, null: false
  field :confirm, Boolean, null: true
  field :message, String, null: true
  field :userErrors, [Types::Error], null: true
end
