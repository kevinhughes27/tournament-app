class Admin::FieldsController < AdminController
  before_action :load_map # could load with tournament to do single query

  def index
    @fields = @tournament.fields
  end

  def show
    @field = @tournament.fields.find(params[:id])
  end

  def new
    @field = @tournament.fields.build
  end

  def create
    @field = @tournament.fields.build(field_params)

    if @field.save
      flash[:notice] = 'Feild created successfully'
      render :show
    else
      flash[:error] = 'Error creating field'
      render :new
    end
  end

  def update
    @field = @tournament.fields.find(params[:id])

    if @field.update_attributes(field_params)
      flash[:notice] = 'Field saved successfully'
    else
      flash[:error] = 'Error saving field'
    end

    render :show
  end

  def destroy
    @field = @tournament.fields.find(params[:id])
    @field.destroy()

    flash[:notice] = 'Field deleted'
    redirect_to action: :index
  end

  private

  def field_params
    @field_params ||= params.require(:field)
      .permit(
        :id,
        :name,
        :lat,
        :long,
        :polygon
      )
  end

  def load_map
    @map = @tournament.map
  end
end
