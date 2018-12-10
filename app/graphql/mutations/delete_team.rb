class Mutations::DeleteTeam < Mutations::BaseMutation
  graphql_name "DeleteTeam"

  argument :input, Inputs::DeleteTeamInput, required: true

  field :team, Types::Team, null: false
  field :success, Boolean, null: false
  field :confirm, Boolean, null: true
  field :not_allowed, Boolean, null: true
  field :message, String, null: false
  field :userErrors, [Types::Error], null: true
end
