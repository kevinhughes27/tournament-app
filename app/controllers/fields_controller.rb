class FieldsController < ApplicationController
  before_action :load_tournament, only: [:index, :create]

  def new
  end

  private

  def field_params
    params.require(:field).permit(:name, :location)
  end
end
