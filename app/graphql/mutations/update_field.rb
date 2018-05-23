module Mutations
  UpdateField = GraphQL::Relay::Mutation.define do
    name "UpdateField"

    input_field :field_id, types.ID
    input_field :name, types.String
    input_field :lat, types.Float
    input_field :long, types.Float
    input_field :geo_json, types.String

    return_field :success, !types.Boolean
    return_field :userErrors, types[types.String]
    return_field :field, Types::Field

    resolve(Auth.protect(Resolvers::UpdateField))
  end
end
