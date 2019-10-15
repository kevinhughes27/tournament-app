class Mutations::ChangeUserPassword < Mutations::BaseMutation
  graphql_name "ChangeUserPassword"

  argument :input, Inputs::ChangeUserPasswordInput, required: true

  field :user, Types::User, null: false
  field :success, Boolean, null: false
  field :message, String, null: true
  field :userErrors, [Types::Error], null: true
end
