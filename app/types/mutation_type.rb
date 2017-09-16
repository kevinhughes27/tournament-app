MutationType = GraphQL::ObjectType.define do
  name "Mutation"
  description "The mutation root for this schema"

  field :submitScore, field: SubmitScoreMutation.field
  field :checkPin, field: CheckPinMutation.field
end
