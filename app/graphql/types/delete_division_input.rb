class Types::DeleteDivisionInput < Types::BaseInputObject
  argument :divisionId, ID, required: true
  argument :confirm, Boolean, required: false
end
