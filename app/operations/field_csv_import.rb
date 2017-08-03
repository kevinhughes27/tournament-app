require 'csv'

class FieldCsvImport < ApplicationOperation
  input :tournament, accepts: Tournament, required: true
  input :file, required: true
  input :ignore, accepts: [true, false], default: false

  class Failed < StandardError
    attr_reader :row_num

    def initialize(row_num, message, *args)
      @row_num = row_num
      super(message, *args)
    end
  end

  def execute
    @row_num = 1
    Field.transaction do
      CSV.foreach(file, headers: true, :header_converters => lambda { |h| csv_header_converter(h) }) do |row|
        @row_num += 1
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
  rescue StandardError => e
    raise Failed(@row_num, e.message)
  end

  private

  def fields
    @fields ||= tournament.fields
  end

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
