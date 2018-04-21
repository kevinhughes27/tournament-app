MutationType = GraphQL::ObjectType.define do
  name "Mutation"
  description "The mutation root for this schema"

  # public
  field :submitScore, field: SubmitScoreMutation.field
  field :checkPin, field: CheckPinMutation.field

  # admin
  field :divisionCreate,  field: DivisionCreateMutation.field,  auth_required: true
  field :divisionDelete,  field: DivisionDeleteMutation.field,  auth_required: true
  field :divisionSeed,    field: DivisionSeedMutation.field,    auth_required: true
  field :divisionUpdate,  field: DivisionUpdateMutation.field,  auth_required: true
  field :fieldDelete,     field: FieldDeleteMutation.field,     auth_required: true
  field :gameSchedule,    field: GameScheduleMutation.field,    auth_required: true
  field :gameUpdateScore, field: GameUpdateScoreMutation.field, auth_required: true
  field :teamDelete,      field: TeamDeleteMutation.field,      auth_required: true
  field :teamUpdate,      field: TeamUpdateMutation.field,      auth_required: true
  field :settingsUpdate,  field: SettingsUpdateMutation.field,  auth_required: true
end
