MutationType = GraphQL::ObjectType.define do
  name "Mutation"
  description "The mutation root for this schema"

  # public
  field :submitScore, field: Mutations::SubmitScore.field
  field :checkPin,    field: Mutations::CheckPin.field

  # admin
  field :updateMap,      field: Mutations::UpdateMap.field,      auth_required: true

  field :createTeam,     field: Mutations::CreateTeam.field,     auth_required: true
  field :updateTeam,     field: Mutations::UpdateTeam.field,     auth_required: true
  field :deleteTeam,     field: Mutations::DeleteTeam.field,     auth_required: true

  field :createDivision, field: Mutations::CreateDivision.field, auth_required: true
  field :updateDivision, field: Mutations::UpdateDivision.field, auth_required: true
  field :seedDivision,   field: Mutations::SeedDivision.field,   auth_required: true
  field :deleteDivision, field: Mutations::DeleteDivision.field, auth_required: true

  field :createField,    field: Mutations::CreateField.field,    auth_required: true
  field :updateField,    field: Mutations::UpdateField.field,    auth_required: true
  field :deleteField,    field: Mutations::DeleteField.field,    auth_required: true

  field :scheduleGame,   field: Mutations::ScheduleGame.field,   auth_required: true

  field :updateScore,    field: Mutations::UpdateScore.field,    auth_required: true

  field :updateSettings, field: Mutations::UpdateSettings.field, auth_required: true
end
