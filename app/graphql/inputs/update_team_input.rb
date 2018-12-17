class Inputs::UpdateTeamInput < Inputs::BaseInputObject
  argument :id, ID, required: true
  argument :name, String, required: false
  argument :email, String, required: false
  argument :phone, String, required: false
end
