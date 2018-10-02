class Inputs::ChangeUserPasswordInput < Inputs::BaseInputObject
  argument :password, String, required: false
  argument :password_confirmation, String, required: false
end
