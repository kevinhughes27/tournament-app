class Mutations::UpdateUser < Mutations::BaseMutation
  graphql_name "UpdateUser"

  argument :input, Inputs::UpdateUserInput, required: true

  field :user, Types::User, null: false
  field :success, Boolean, null: false
  field :message, String, null: true
  field :userErrors, [Types::Error], null: true
end
