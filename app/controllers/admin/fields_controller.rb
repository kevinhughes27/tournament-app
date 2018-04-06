class Admin::FieldsController < AdminController
  before_action -> { @map = @tournament.map }
  before_action :load_field, only: [:show, :update, :destroy]
  before_action :load_fields, only: [:index, :new, :create, :show, :update, :export_csv]

  def index
  end

  def show
  end

  def new
    @field = @tournament.fields.build(lat: @map.lat, long: @map.long)
  end

  def create
    @field = @tournament.fields.create(field_params)
    if @field.persisted?
      flash[:notice] = 'Field was successfully created.'
      redirect_to admin_field_path(@field)
    else
      render :new
    end
  end

  def update
    @field.update(field_params)
    if @field.errors.present?
      render :show
    else
      flash[:notice] = 'Field was successfully updated.'
      redirect_to admin_field_path(@field)
    end
  end

  def destroy
    delete = FieldDelete.new(@field, confirm: params[:confirm] == 'true')
    delete.perform

    if delete.succeeded?
      flash[:notice] = 'Field was successfully destroyed.'
      redirect_to admin_fields_path
    elsif delete.confirmation_required?
      render partial: 'confirm_delete', status: :unprocessable_entity
    else
      flash[:error] = 'Field could not be deleted.'
      render :show
    end
  end

  def sample_csv
    respond_to do |format|
      format.csv { send_data FieldCsv.sample, filename: 'sample_fields.csv' }
    end
  end

  def import_csv
    file = params[:csv_file].path
    ignore = params[:match_behaviour] == 'ignore'

    import = FieldCsvImport.new(@tournament, file, ignore: ignore)
    import.perform

    if import.succeeded?
      flash[:notice] = 'Fields imported successfully'
      redirect_to action: :index
    else
      flash[:import_error] = "Row: #{import.row_num} #{import.output}"
      redirect_to action: :index
    end
  end

  def export_csv
    csv = FieldCsvExport.perform(@fields)

    respond_to do |format|
      format.csv { send_data csv, filename: 'fields.csv' }
    end
  end

  private

  def load_fields
    @fields = @tournament.fields.order(:name)
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
end
