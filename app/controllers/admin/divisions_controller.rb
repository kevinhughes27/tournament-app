class Admin::DivisionsController < AdminController
  before_action :load_division, only: [:show, :edit, :update, :destroy, :update_teams, :seed]
  before_action :check_update_safety, only: [:update]
  before_action :check_seed_safety, only: [:seed]
  before_action :check_delete_safety, only: [:destroy]

  def index
    @divisions = @tournament.divisions.includes(:teams, games: [:home, :away])
  end

  def show
  end

  def edit
  end

  def new
    @division = @tournament.divisions.build
    @division.bracket_type = 'USAU 8.1'
  end

  def create
    @division = @tournament.divisions.create(division_params)
    if @division.persisted?
      flash[:notice] = 'Division was successfully create.'
      redirect_to admin_division_path(@division)
    else
      flash[:error] = 'Division could not be created.'
      render :new
    end
  end

  def update
    @division.update_attributes(division_params)
    if @division.errors.present?
      flash[:error] = 'Division could not be updated.'
      render :edit
    else
      flash[:notice] = 'Division was successfully updated.'
      redirect_to admin_division_path(@division)
    end
  end

  def destroy
    @division.destroy()
    flash[:notice] = 'Division was successfully destroyed.'
    redirect_to admin_divisions_path
  end

  def seed
    if request.post?
      begin
        @division.seed
        flash[:notice] = 'Division seeded'
        redirect_to admin_division_path(@division)
      rescue => error
        flash[:error] = error.message
        render :seed
      end
    end
  end

  def update_teams
    team_ids = params[:team_ids]
    @teams = @division.teams

    Team.transaction do
      team_ids.each_with_index do |team_id, idx|
        team = @teams.detect { |t| t.id == team_id.to_i}
        team.assign_attributes(seed: params[:seeds][idx])
        raise if team.seed_changed? && !team.allow_change?
        team.save!
      end
    end

    flash.now[:notice] = 'Seeds updated'
    render :seed
  rescue => e
    render partial: 'unable_to_update_teams', status: :not_allowed
  end

  private

  def check_update_safety
    @division.assign_attributes(division_params)

    # this is correct since as long as we don't render we continue
    # with the controller action
    if !(params[:confirm] == 'true' || @division.safe_to_change?)
      render partial: 'confirm_update', status: :unprocessable_entity
    end
  end

  def check_seed_safety
    unless params[:confirm] == 'true' || @division.safe_to_seed?
      render partial: 'confirm_seed', status: :unprocessable_entity
    end
  end

  def check_delete_safety
    unless params[:confirm] == 'true' || @division.safe_to_delete?
      render partial: 'confirm_delete', status: :unprocessable_entity
    end
  end

  def load_division
    @division = @tournament.divisions.includes(:teams, games: [:home, :away]).find(params[:id])
  end

  def division_params
    @bracket_params ||= params.require(:division).permit(
      :name,
      :num_teams,
      :num_days,
      :bracket_type
    )
  end
end
