class Admin::DivisionsController < AdminController

  def index
    @divisions = @tournament.divisions
  end

  def show
    @division = @tournament.divisions.find(params[:id])
  end

  def new
    @division = @tournament.divisions.build
  end

  def create
    @division = @tournament.divisions.create(division_params)
    respond_with @division
  end

  def update
    @division = @tournament.divisions.find(params[:id])
    @division.update_attributes(division_params)
    respond_with @division
  end

  def destroy
    @division = @tournament.divisions.find(params[:id]).destroy()
    respond_with @division
  end

  def update_teams
    @division = @tournament.divisions.find(params[:id])

    @teams = Team.where( id: params[:team_ids] )
    @teams.each_with_index do |team, idx|
      team.update_attribute( :seed, params[:seeds][idx] )
    end

    flash.now[:notice] = 'Seeds updated'
    render :show
  end

  def seed
    @division =@tournament.divisions.find(params[:id])
    @teams = @division.teams.order(:seed)

    begin
      seeds = @teams.pluck(:seed).sort
      seeds.each_with_index do |seed, idx|
        raise Division::AmbiguousSeedList.new('ambiguous seed list') unless seed == (idx+1)
      end

      @division.seed(@teams)

      flash.now[:notice] = 'Division seeded'
    rescue => error
      flash.now[:error] = error.message
    ensure
      render :show
    end
  end

  private

  def division_params
    @bracket_params ||= params.require(:division).permit(
      :name,
      :num_teams,
      :bracket_type
    )
  end

end
