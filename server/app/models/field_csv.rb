require 'csv'

class FieldCsv
  def self.sample
    CSV.generate do |csv|
      csv << ['Name', 'Latitude', 'Longitude', 'Geo JSON']
      csv << ['UPI1', 45.2456681689589, -75.6163644790649, Field.example_geo_json]
    end
  end
end
