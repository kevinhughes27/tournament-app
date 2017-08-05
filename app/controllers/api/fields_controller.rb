module Api
  class FieldsController < BaseController
    def index
      fields = @tournament.fields
      render json: fields
    end
  end
end
