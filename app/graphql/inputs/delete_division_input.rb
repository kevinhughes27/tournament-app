class Inputs::DeleteDivisionInput < Inputs::BaseInputObject
  argument :divisionId, ID, required: true
  argument :confirm, Boolean, required: false
end
