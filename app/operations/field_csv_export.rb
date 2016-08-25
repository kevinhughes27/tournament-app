require 'csv'

class FieldCsvExport < ApplicationOperation
  processes :fields
  property :fields, accepts: lambda { |fields| fields.all?{ |field| field.is_a?(Field) } }

  def execute
    csv = CSV.generate do |csv|
      csv << ['Name', 'Latitude', 'Longitude', 'Geo JSON']
      fields.each do |field|
        csv << [field.name, field.lat, field.long, field.geo_json]
      end
    end

    csv
  end
end