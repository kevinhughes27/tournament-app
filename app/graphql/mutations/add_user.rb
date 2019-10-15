class Mutations::AddUser < Mutations::BaseMutation
  graphql_name "AddUser"

  argument :input, Inputs::AddUserInput, required: true

  field :user, Types::User, null: false
  field :success, Boolean, null: false
  field :message, String, null: true
  field :userErrors, [Types::Error], null: true
end
