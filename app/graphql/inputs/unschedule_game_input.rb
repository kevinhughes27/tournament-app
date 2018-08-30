class Inputs::UnscheduleGameInput < Inputs::BaseInputObject
  argument :gameId, ID, required: true
end
