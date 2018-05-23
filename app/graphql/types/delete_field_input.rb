class Types::DeleteFieldInput < Types::BaseInputObject
  argument :fieldId, ID, required: true
  argument :confirm, Boolean, required: false
end
