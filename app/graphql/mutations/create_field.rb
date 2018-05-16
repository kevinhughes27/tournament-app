module Mutations
  CreateField = GraphQL::Relay::Mutation.define do
    name "CreateField"

    input_field :name, types.String
    input_field :lat, types.Float
    input_field :long, types.Float
    input_field :geo_json, types.String

    return_field :success, !types.Boolean
    return_field :userErrors, types[types.String]
    return_field :field, FieldType

    resolve(Auth.protect(Resolvers::CreateField))
  end
end
