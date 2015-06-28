class Admin::FieldsController < AdminController

  def index
    @map = @tournament.map
    @fields = @tournament.fields
  end

  def create
    @map = @tournament.map
    @fields = @tournament.fields
    update_fields && delete_unused_fields && create_fields

    render :index
  end

  private

  def update_fields
    fields_params.map do |field_params|
      next unless field_params[:id]
      field = @fields.detect{ |f| f.id == field_params[:id].to_i }
      field.update_attributes(field_params)
    end
  end

  def delete_unused_fields
    old_fields = @fields.pluck(:id)
    new_fields = fields_params.map{ |p| p[:id].to_i }
    unused = old_fields - new_fields

    unused.each do |id|
      Field.where(id: id).destroy
      @fields.delete_if{ |f| f.id == id }
    end
  end

  def create_fields
    fields_params.each do |field_params|
      next if field_params[:id]
      field = @tournament.fields.build(field_params)
      field.save
      @fields << field
    end
  end

  def fields_params
    @fields_params ||= params.permit(
      fields: [
        :id,
        :name,
        :lat,
        :long,
        :polygon
      ]
    )

    @fields_params[:fields] || []
  end
end
