class Inputs::DeleteFieldInput < Inputs::BaseInputObject
  argument :fieldId, ID, required: true
  argument :confirm, Boolean, required: false
end
