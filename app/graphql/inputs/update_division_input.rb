class Inputs::UpdateDivisionInput < Inputs::BaseInputObject
  argument :id, ID, required: true
  argument :name, String, required: false
  argument :numTeams, Int, required: false
  argument :numDays, Int, required: false
  argument :bracketType, String, required: false
  argument :confirm, Boolean, required: false
end
