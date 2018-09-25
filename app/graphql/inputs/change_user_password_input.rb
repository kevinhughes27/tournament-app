class Inputs::ChangeUserPasswordInput < Inputs::BaseInputObject
  argument :id, ID, required: true
  argument :password, String, required: false
  argument :password_confirmation, String, required: false

end
