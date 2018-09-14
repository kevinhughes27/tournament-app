class Inputs::UpdateUserInput < Inputs::BaseInputObject
  argument :id, ID, required: true
  argument :name, String, required: false
  argument :email, String, required: false
  argument :password, String, required: false
end
