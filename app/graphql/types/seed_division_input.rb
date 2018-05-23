class Types::SeedDivisionInput < Types::BaseInputObject
  argument :divisionId, ID, required: true
  argument :teamIds, [ID], required: false
  argument :seeds, [Int], required: false
  argument :confirm, Boolean, required: false
end
