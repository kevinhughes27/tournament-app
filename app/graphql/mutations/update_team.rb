class Mutations::UpdateTeam < Mutations::BaseMutation
  graphql_name "UpdateTeam"

  argument :input, Inputs::UpdateTeamInput, required: true

  field :team, Types::Team, null: false
  field :success, Boolean, null: false
  field :message, String, null: true
  field :userErrors, [Types::Error], null: true
end
