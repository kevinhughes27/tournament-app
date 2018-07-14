class Mutations::UpdateTeam < Mutations::BaseMutation
  graphql_name "UpdateTeam"

  argument :input, Inputs::UpdateTeamInput, required: true

  field :team, Types::Team, null: false
  field :success, Boolean, null: false
  field :confirm, Boolean, null: true
  field :not_allowed, Boolean, null: true
  field :message, String, null: true
  field :userErrors, [Types::Error], null: true
end
