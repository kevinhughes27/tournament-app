class Admin::FieldsController < AdminController
  skip_before_action :load_tournament
  before_action :load_tournament_with_map

  def index
    @fields = @tournament.fields
  end

  def show
    @field = @tournament.fields.find(params[:id])
  end

  def new
    @field = @tournament.fields.build(lat: @map.lat, long: @map.long)
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
        :geo_json
      )
  end

  def load_tournament_with_map
    if params[:tournament_id]
      @tournament = Tournament.includes(:map).friendly.find(params[:tournament_id])
    else
      @tournament = Tournament.includes(:map).friendly.find(params[:id])
    end

    @map = @tournament.map
  end
end
