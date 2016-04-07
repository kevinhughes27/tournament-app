require 'csv'

class Admin::FieldsController < AdminController
  include LoadTournamentWithMap
  TAB_KEY = 'fieldsTab'

  before_action :load_field, only: [:show, :update, :destroy]
  before_action :load_fields, only: [:index, :new, :create, :show, :update]
  before_action :check_delete_safety, only: [:destroy]

  def index
  end

  def show
  end

  def new
    @field = @tournament.fields.build(lat: @map.lat, long: @map.long)
  end

  def create
    @field = @tournament.fields.create(field_params)
    respond_with @field
  end

  def update
    @field.update_attributes(field_params)
    respond_with @field
  end

  def destroy
    @field.destroy()
    respond_with @field
  end

  def sample_csv
    csv = CSV.generate do |csv|
      csv << ['Name', 'Latitude', 'Longitude', 'Geo JSON']
      csv << ['UPI1', 45.2456681689589, -75.6163644790649, example_geo_json]
    end

    respond_to do |format|
      format.csv { send_data csv, filename: 'sample_fields.csv' }
    end
  end

  def import_csv
    file_path = params[:csv_file].path
    ignore = params[:match_behaviour] == 'ignore'

    @fields = @tournament.fields

    rowNum = 1
    Field.transaction do
      CSV.foreach(file_path, headers: true, :header_converters => lambda { |h| csv_header_converter(h) }) do |row|
        rowNum += 1
        attributes = row.to_hash.with_indifferent_access
        attributes = csv_params(attributes)

        if field = @fields.detect{ |f| f.name == attributes[:name] }
          next if ignore
          field.update_attributes!(attributes)
        else
          @tournament.fields.create!(attributes)
        end
      end
    end

    flash[:notice] = 'Fields imported successfully'
    redirect_to action: :index
  rescue => e
    flash[:alert] = "Error importing fields. Row: #{rowNum} #{e}"
    redirect_to action: :index
  end

  def export_csv
    @fields = @tournament.fields

    csv = CSV.generate do |csv|
      csv << ['Name', 'Latitude', 'Longitude', 'Geo JSON']
      @fields.each do |field|
        csv << [field.name, field.lat, field.long, field.geo_json]
      end
    end

    respond_to do |format|
      format.csv { send_data csv, filename: 'fields.csv' }
    end
  end

  private

  def check_delete_safety
    unless params[:confirm] == 'true' || @field.safe_to_delete?
      render partial: 'confirm_delete', status: :unprocessable_entity
    end
  end

  def load_fields
    @fields = @tournament.fields
  end

  def load_field
    @field ||= if @fields
      @fields.detect{ |f| f.id == params[:id] }
    else
      @tournament.fields.find(params[:id])
    end
  end

  def field_params
    @field_params ||= params.require(:field)
      .permit(
        :name,
        :lat,
        :long,
        :geo_json
      )
  end

  def csv_params(attributes)
    attributes.slice(
      :name,
      :lat,
      :long,
      :geo_json
    )
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

  def example_geo_json
    "{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-75.61704058530103,45.24560112337739],[-75.61682149825708,45.24531101502135],[-75.61568837209097,45.24573520582302],[-75.61590746188978,45.2460253137602],[-75.61704058530103,45.24560112337739]]]}}"
  end
end
