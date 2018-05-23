class Types::UpdateFieldInput < Types::BaseInputObject
  argument :fieldId, ID, required: true
  argument :name, String, required: false
  argument :lat, Float, required: false
  argument :long, Float, required: false
  argument :geoJson, String, required: false
end
