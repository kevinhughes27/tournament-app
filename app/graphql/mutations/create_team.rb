class Mutations::CreateTeam < Mutations::BaseMutation
  graphql_name "CreateTeam"

  argument :input, Inputs::CreateTeamInput, required: true

  field :team, Types::Team, null: true
  field :success, Boolean, null: false
  field :message, String, null: true
  field :userErrors, [Types::Error], null: true
end
