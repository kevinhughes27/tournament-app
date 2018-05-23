module Mutations
  CreateDivision = GraphQL::Relay::Mutation.define do
    name "CreateDivision"

    input_field :name, types.String
    input_field :num_teams, types.Int
    input_field :num_days, types.Int
    input_field :bracket_type, types.String

    return_field :success, !types.Boolean
    return_field :userErrors, types[types.String]
    return_field :division, Types::Division

    resolve(Auth.protect(Resolvers::CreateDivision))
  end
end
