class Inputs::ChangeUserPasswordInput < Inputs::BaseInputObject
  argument :password, String, required: true
  argument :password_confirmation, String, required: true
end
