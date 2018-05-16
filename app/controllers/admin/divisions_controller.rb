class Admin::DivisionsController < AdminController
  before_action :load_division, only: [:show, :edit, :destroy, :update_teams, :seed]

  def index
    @divisions = @tournament.divisions.includes(:teams, games: [:home, :away])
  end

  def show
    @bracket_tree = BracketDb::to_tree(@division.games)
  end

  def edit
  end

  def new
    @division = @tournament.divisions.build(bracket_type: 'USAU 8.1')
  end

  def create
    input = params_to_input(division_params)

    result = execute_graphql(
      'createDivision',
      'CreateDivisionInput',
      input,
      "{
         success,
         errors,
         division { id, name, num_teams, num_days, bracket_type }
       }"
    )

    @division = Division.new(result['division'])
    @errors = result['errors']

    if result['success']
      flash[:notice] = 'Division was successfully created.'
      redirect_to admin_division_path(@division)
    else
      render :new
    end
  end

  def update
    input = params_to_input(division_params, params, 'division_id')

    result = execute_graphql(
      'updateDivision',
      'UpdateDivisionInput',
      input,
      "{
         success,
         confirm,
         errors,
         division { id, name, num_teams, num_days, bracket_type }
       }"
    )

    @division = Division.new(result['division'])
    @errors = result['errors']

    if result['success']
      flash[:notice] = 'Division was successfully updated.'
      redirect_to admin_division_path(@division)
    elsif result['confirm']
      @message = result['errors'].first
      render partial: 'confirm_update', status: :unprocessable_entity
    else
      render :edit
    end
  end

  def destroy
    input = params_to_input({}, params, 'division_id')

    result = execute_graphql(
      'deleteDivision',
      'DeleteDivisionInput',
      input,
      "{
         success,
         confirm
       }"
    )

    if result['success']
      flash[:notice] = 'Division was successfully destroyed.'
      redirect_to admin_divisions_path
    elsif result['confirm']
      render partial: 'confirm_delete', status: :unprocessable_entity
    else
      flash[:error] = 'Division could not be deleted.'
      render :show
    end
  end

  def seed
    if request.post?
      input = params_to_input(seed_params, params, 'division_id')

      result = execute_graphql(
        'seedDivision',
        'SeedDivisionInput',
        input,
        "{
           success,
           confirm,
           errors
         }"
      )

      if result['success']
        flash[:notice] = 'Division seeded'
        redirect_to admin_division_path(@division)
      elsif result['confirm']
        render partial: 'confirm_seed', status: :unprocessable_entity
      else
        flash[:seed_error] = result['errors'].first
      end
    end
  end

  private

  def load_division
    @division = @tournament.divisions.includes(:teams, games: [:home, :away, :score_reports, :score_disputes]).find(params[:id])
  end

  def division_params
    @division_params ||= params.require(:division).permit(
      :name,
      :num_teams,
      :num_days,
      :bracket_type
    )
  end

  def seed_params
    params.slice(:team_ids, :seeds)
  end
end
