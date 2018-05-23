class Mutations::UpdateTeam < Mutations::BaseMutation
  graphql_name "UpdateTeam"

  argument :input, Types::UpdateTeamInput, required: true

  field :success, Boolean, null: false
  field :confirm, Boolean, null: true
  field :not_allowed, Boolean, null: true
  field :userErrors, [String], null: true
  field :team, Types::Team, null: false
end
