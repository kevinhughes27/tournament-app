class FieldsController < ApplicationController
  before_action :load_tournament, only: [:index, :create]

  def index
  end

  def create
    fields_params.each do |field_params|
      field = @tournament.fields.build(field_params)
      field.save
    end

    redirect_to tournament_fields_path(@tournament), notice: 'Fields saved.'
  end

  private

  def load_tournament
    if params[:tournament_id]
      @tournament = Tournament.friendly.find(params[:tournament_id])
    else
      @tournament = Tournament.friendly.find(params[:id])
    end
  end

  def fields_params
    @fields_params ||= params.permit(
      fields: [
        :name,
        :lat,
        :long,
        :polygon
      ]
    )

    @fields_params[:fields]
  end
end
