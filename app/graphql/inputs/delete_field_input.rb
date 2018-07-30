class Inputs::DeleteFieldInput < Inputs::BaseInputObject
  argument :id, ID, required: true
  argument :confirm, Boolean, required: false
end
