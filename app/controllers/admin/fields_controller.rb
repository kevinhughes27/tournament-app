class Admin::FieldsController < AdminController

  def index
    @fields = @tournament.fields
  end

  def create
    update_fields && delete_unused_fields && create_fields
    redirect_to tournament_fields_path(@tournament), notice: 'Fields saved.'
  end

  private

  def update_fields
    fields_params.each do |field_params|
      next unless field_params[:id]
      field = Field.find(field_params[:id])
      field.update_attributes(field_params)
    end
  end

  def delete_unused_fields
    old_fields = @tournament.fields.pluck(:id)
    new_fields = fields_params.map{ |p| p[:id].to_i }
    unused = old_fields - new_fields
    Field.where(id: unused).destroy_all
  end

  def create_fields
    fields_params.each do |field_params|
      next if field_params[:id]
      field = @tournament.fields.build(field_params)
      field.save
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
