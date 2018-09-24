class Inputs::ChangeUserPasswordInput < Inputs::BaseInputObject
  argument :id, ID, required: true
  argument :password, String, required: false
  argument :confirm_password, String, required: false

end
