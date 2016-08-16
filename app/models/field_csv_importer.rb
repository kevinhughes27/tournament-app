class FieldCsvImporter
  attr_reader :tournament, :file, :ignore

  def initialize(tournament, file, ignore)
    @tournament = tournament
    @file = file
    @ignore = ignore
  end

  def run!
    fields = tournament.fields

    rowNum = 1
    Field.transaction do
      CSV.foreach(file, headers: true, :header_converters => lambda { |h| csv_header_converter(h) }) do |row|
        rowNum += 1
        attributes = row.to_hash.with_indifferent_access
        attributes = csv_params(attributes)

        if field = fields.detect{ |f| f.name == attributes[:name] }
          next if ignore
          field.update!(attributes)
        else
          tournament.fields.create!(attributes)
        end
      end
    end
  end

  private

  def csv_header_converter(header)
    case header
    when 'Latitude'
      'lat'
    when 'Longitude'
      'long'
    when 'Geo JSON'
      'geo_json'
    else
      header.try(:downcase).strip
    end
  end

  def csv_params(attributes)
    attributes.slice(
      :name,
      :lat,
      :long,
      :geo_json
    )
  end
end
