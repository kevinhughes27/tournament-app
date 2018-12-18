class Inputs::CreateSeedInput < Inputs::BaseInputObject
  argument :divisionId, ID, required: false
  argument :teamId, ID, required: false
  argument :rank, Int, required: false
end
