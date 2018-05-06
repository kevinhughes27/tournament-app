module Mutations
  DivisionCreate = GraphQL::Relay::Mutation.define do
    name "DivisionCreate"

    input_field :name, types.String
    input_field :num_teams, types.Int
    input_field :num_days, types.Int
    input_field :bracket_type, types.String

    return_field :success, !types.Boolean
    return_field :errors, types[types.String]
    return_field :division, DivisionType

    resolve(Auth.protect(Resolvers::DivisionCreate))
  end
end
