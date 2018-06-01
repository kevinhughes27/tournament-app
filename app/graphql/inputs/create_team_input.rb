class Inputs::CreateTeamInput < Inputs::BaseInputObject
  argument :name, String, required: false
  argument :email, String, required: false
  argument :phone, String, required: false
  argument :divisionId, ID, required: false
  argument :seed, Int, required: false
end
