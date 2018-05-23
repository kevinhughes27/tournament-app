class Types::Mutation < Types::BaseObject
  # public
  field :submitScore, mutation: Mutations::SubmitScore
  field :checkPin,    mutation: Mutations::CheckPin

  # admin
  field :updateMap,      mutation: Mutations::UpdateMap,      auth_required: true

  field :createTeam,     mutation: Mutations::CreateTeam,     auth_required: true
  field :updateTeam,     mutation: Mutations::UpdateTeam,     auth_required: true
  field :deleteTeam,     mutation: Mutations::DeleteTeam,     auth_required: true

  field :createDivision, mutation: Mutations::CreateDivision, auth_required: true
  field :updateDivision, mutation: Mutations::UpdateDivision, auth_required: true
  field :seedDivision,   mutation: Mutations::SeedDivision,   auth_required: true
  field :deleteDivision, mutation: Mutations::DeleteDivision, auth_required: true

  field :createField,    mutation: Mutations::CreateField,    auth_required: true
  field :updateField,    mutation: Mutations::UpdateField,    auth_required: true
  field :deleteField,    mutation: Mutations::DeleteField,    auth_required: true

  field :scheduleGame,   mutation: Mutations::ScheduleGame,   auth_required: true

  field :updateScore,    mutation: Mutations::UpdateScore,    auth_required: true

  field :updateSettings, mutation: Mutations::UpdateSettings, auth_required: true
end
