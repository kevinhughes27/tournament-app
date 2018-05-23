class Mutations::CreateTeam < Mutations::BaseMutation
  graphql_name "CreateTeam"

  argument :input, Types::CreateTeamInput, required: true

  field :success, Boolean, null: false
  field :userErrors, [String], null: true
  field :team, Types::Team, null: false
end
