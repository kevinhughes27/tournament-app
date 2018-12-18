class Inputs::DeleteSeedInput < Inputs::BaseInputObject
  argument :divisionId, ID, required: false
  argument :teamId, ID, required: false
  argument :rank, Int, required: false
  argument :confirm, Boolean, required: false
end
