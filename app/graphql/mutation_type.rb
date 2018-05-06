MutationType = GraphQL::ObjectType.define do
  name "Mutation"
  description "The mutation root for this schema"

  # public
  field :submitScore, field: Mutations::SubmitScore.field
  field :checkPin,    field: Mutations::CheckPin.field

  # admin
  field :divisionCreate,  field: Mutations::DivisionCreate.field,  auth_required: true
  field :divisionDelete,  field: Mutations::DivisionDelete.field,  auth_required: true
  field :divisionSeed,    field: Mutations::DivisionSeed.field,    auth_required: true
  field :divisionUpdate,  field: Mutations::DivisionUpdate.field,  auth_required: true
  field :fieldDelete,     field: Mutations::FieldDelete.field,     auth_required: true
  field :gameSchedule,    field: Mutations::GameSchedule.field,    auth_required: true
  field :gameUpdateScore, field: Mutations::GameUpdateScore.field, auth_required: true
  field :teamDelete,      field: Mutations::TeamDelete.field,      auth_required: true
  field :teamUpdate,      field: Mutations::TeamUpdate.field,      auth_required: true
  field :settingsUpdate,  field: Mutations::SettingsUpdate.field,  auth_required: true
end
