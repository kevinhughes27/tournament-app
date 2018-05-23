class Types::DeleteTeamInput < Types::BaseInputObject
  argument :teamId, ID, required: true
  argument :confirm, Boolean, required: false
end
