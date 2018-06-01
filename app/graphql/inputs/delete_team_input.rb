class Inputs::DeleteTeamInput < Inputs::BaseInputObject
  argument :teamId, ID, required: true
  argument :confirm, Boolean, required: false
end
