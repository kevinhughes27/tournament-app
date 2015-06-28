class Admin::SpiritsController < AdminController
  before_action :set_spirit, only: [:show, :edit, :update, :destroy]

  # GET /spirits
  def index
    @spirits = Spirit.all
  end

  # GET /spirits/1
  def show
  end

  # GET /spirits/new
  def new
    @spirit = Spirit.new
  end

  # GET /spirits/1/edit
  def edit
  end

  # POST /spirits
  def create
    @spirit = Spirit.new(spirit_params)

    if @spirit.save
      redirect_to @spirit, notice: 'Spirit was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /spirits/1
  def update
    if @spirit.update(spirit_params)
      redirect_to @spirit, notice: 'Spirit was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /spirits/1
  def destroy
    @spirit.destroy
    redirect_to spirits_url, notice: 'Spirit was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spirit
      @spirit = Spirit.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def spirit_params
      params.require(:spirit).permit(:author_id, :subject_id, :rule, :foul, :fair, :tude, :comm)
    end
end
