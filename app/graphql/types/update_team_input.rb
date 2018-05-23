class Types::UpdateTeamInput < Types::BaseInputObject
  argument :teamId, ID, required: true
  argument :name, String, required: false
  argument :email, String, required: false
  argument :phone, String, required: false
  argument :divisionId, ID, required: false
  argument :seed, Int, required: false
  argument :confirm, Boolean, required: false
end
