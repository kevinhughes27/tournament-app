class Types::UpdateMapInput < Types::BaseInputObject
  argument :lat, Float, required: true
  argument :long, Float, required: true
  argument :zoom, Int, required: true
end
