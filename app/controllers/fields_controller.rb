class FieldsController < ApplicationController
  before_action :set_field, only: [:show, :edit, :update, :destroy]

  # GET /fields
  def index
    @fields = Field.all
  end

  # GET /fields/1
  def show
  end

  # GET /fields/new
  def new
    @tournament = Tournament.find(params[:tournament_id])
  end

  # GET /fields/1/edit
  def edit
  end

  # POST /fields
  def create
    @tournament = Tournament.find(params[:tournament_id])
    @tournament.update_attributes(tournament_params)

    redirect_to new_tournament_field_path(@tournament), notice: 'Fields updated'
  end

  # PATCH/PUT /fields/1
  def update
    if @field.update(field_params)
      redirect_to @field, notice: 'Field was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /fields/1
  def destroy
    @field.destroy
    redirect_to fields_url, notice: 'Field was successfully destroyed.'
  end

  private
    def tournament_params
      params.require(:tournament).permit(
        :zoom,
        :lat,
        :long
      )
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_field
      @field = Field.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def field_params
      params.require(:field).permit(:name, :location)
    end
end
