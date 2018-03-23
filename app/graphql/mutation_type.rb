MutationType = GraphQL::ObjectType.define do
  name "Mutation"
  description "The mutation root for this schema"

  # public
  field :submitScore, field: SubmitScoreMutation.field
  field :checkPin, field: CheckPinMutation.field

  # admin
  field :gameUpdateScore, field: GameUpdateScoreMutation.field do
    visibility -> (ctx) { Auth.visible(ctx) }
  end
end
