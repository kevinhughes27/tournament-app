class Inputs::ScheduleGameInput < Inputs::BaseInputObject
  argument :gameId, ID, required: true
  argument :fieldId, ID, required: true
  argument :startTime, Types::DateTime, required: true
  argument :endTime, Types::DateTime, required: true
end
