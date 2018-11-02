require 'csv'

class FieldCsvExport < ApplicationOperation
  input :fields, required: true, accepts: lambda { |fields| fields.all?{ |field| field.is_a?(Field) } }

  def execute
    csv = CSV.generate do |csv|
      csv << ['Name', 'Latitude', 'Longitude', 'GeoJSON']
      fields.each do |field|
        csv << [field.name, field.lat, field.long, field.geo_json]
      end
    end

    csv
  end
end
