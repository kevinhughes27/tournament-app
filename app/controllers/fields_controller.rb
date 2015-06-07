class FieldsController < ApplicationController
  before_action :load_tournament, only: [:index, :create]

  def index
  end

  def create
  end

  private

  def field_params
    params.require(:field).permit(:name, :location)
  end
end
