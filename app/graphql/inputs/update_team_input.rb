class Inputs::UpdateTeamInput < Inputs::BaseInputObject
  argument :teamId, ID, required: true
  argument :name, String, required: false
  argument :email, String, required: false
  argument :phone, String, required: false
  argument :divisionId, ID, required: false
  argument :seed, Types::NullableInt, required: false
  argument :confirm, Boolean, required: false
end
