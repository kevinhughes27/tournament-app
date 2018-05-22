module Mutations
  UpdateSettings = GraphQL::Relay::Mutation.define do
    name "UpdateSettings"

    input_field :name, types.String
    input_field :handle, types.String
    input_field :score_submit_pin, types.Int
    input_field :game_confirm_setting, types.String
    input_field :timezone, types.String
    input_field :confirm, types.Boolean

    return_field :success, !types.Boolean
    return_field :confirm, types.Boolean
    return_field :userErrors, types[types.String]

    resolve(Auth.protect(Resolvers::UpdateSettings))
  end
end
