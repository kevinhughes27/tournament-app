class Inputs::CreateFieldInput < Inputs::BaseInputObject
  argument :name, String, required: false
  argument :lat, Float, required: false
  argument :long, Float, required: false
  argument :geoJson, String, required: false
end
