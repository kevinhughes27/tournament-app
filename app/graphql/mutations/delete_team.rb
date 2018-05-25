class Mutations::DeleteTeam < Mutations::BaseMutation
  graphql_name "DeleteTeam"

  argument :input, Inputs::DeleteTeamInput, required: true

  field :success, Boolean, null: false
  field :confirm, Boolean, null: true
  field :not_allowed, Boolean, null: true
  field :userErrors, [String], null: true
end
