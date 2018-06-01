class Inputs::UpdateMapInput < Inputs::BaseInputObject
  argument :lat, Float, required: true
  argument :long, Float, required: true
  argument :zoom, Int, required: true
end
