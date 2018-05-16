module Mutations
  FieldUpdate = GraphQL::Relay::Mutation.define do
    name "FieldUpdate"

    input_field :field_id, types.ID
    input_field :name, types.String
    input_field :lat, types.Float
    input_field :long, types.Float
    input_field :geo_json, types.String

    return_field :success, !types.Boolean
    return_field :errors, types[types.String]
    return_field :field, FieldType

    resolve(Auth.protect(Resolvers::FieldUpdate))
  end
end
