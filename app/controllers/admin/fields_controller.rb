class Admin::FieldsController < AdminController

  def index
    @map = @tournament.map
    @fields = @tournament.fields
  end

  def create
    @map = @tournament.map
    @fields = Field.update_set(@tournament.fields, fields_params)

    render :index
  end

  private

  def fields_params
    @fields_params ||= params.permit(fields: [
      :id,
      :name,
      :lat,
      :long,
      :polygon
    ])
    @fields_params[:fields] ||= []
    @fields_params[:fields].each{ |f| f[:tournament_id] = @tournament.id }
  end
end
