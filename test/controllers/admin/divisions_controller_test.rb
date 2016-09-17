require 'test_helper'

class Admin::DivisionsControllerTest < ActionController::TestCase
  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    @division = divisions(:open)
    sign_in users(:kevin)
  end

  test "get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:division)
  end

  test "get show" do
    get :show, params: { id: @division.id }
    assert_response :success
    assert_not_nil assigns(:division)
  end

  test "get edit" do
    get :edit, params: { id: @division.id }
    assert_response :success
    assert_not_nil assigns(:division)
  end

  test "get index" do
    get :index
    assert_response :success
  end

  test "blank slate" do
    @tournament.divisions.destroy_all
    get :index
    assert_response :success
    assert_match 'blank-slate', response.body
  end

  test "create a division" do
    assert_difference "Division.count" do
      post :create, params: { division: division_params }

      division = assigns(:division)
      assert_redirected_to admin_division_path(division)
    end
  end

  test "create a division error re-renders form" do
    params = division_params
    params.delete(:name)

    assert_no_difference "Division.count" do
      post :create, params: { division: params }

      division = assigns(:division)
      assert division.errors.present?
      assert_template :new
    end
  end

  test "update a division" do
    put :update, params: { id: @division.id, division: division_params }

    assert_redirected_to admin_division_path(@division)
    assert_equal division_params[:name], @division.reload.name
  end

  test "update a division (unsafe)" do
    params = division_params.merge(bracket_type: 'single_elimination_4')
    put :update, params: { id: @division.id, division: params }

    assert_response :unprocessable_entity
    assert_template 'admin/divisions/_confirm_update'
  end

  test "update a division (unsafe) + confirm" do
    params = division_params.merge(bracket_type: 'single_elimination_4')
    put :update, params: { id: @division.id, division: params, confirm: 'true' }

    assert_redirected_to admin_division_path(@division)
    assert_equal params[:bracket_type], @division.reload.bracket_type
  end

  test "update a division with errors" do
    params = division_params
    params.delete(:name)

    put :update, params: { id: @division.id, division: params }

    assert_redirected_to admin_division_path(@division)
    refute_equal division_params[:name], @division.reload.name
  end

  test "delete a division" do
    division = divisions(:women)
    assert_difference "Division.count", -1 do
      delete :destroy, params: { id: division.id }
      assert_redirected_to admin_divisions_path
    end
  end

  test "delete a division needs confirm" do
    assert_no_difference "Division.count" do
      delete :destroy, params: { id: @division.id }
      assert_response :unprocessable_entity
      assert_template 'admin/divisions/_confirm_delete'
    end
  end

  test "confirm delete a division" do
    assert_difference "Division.count", -1 do
      delete :destroy, params: { id: @division.id, confirm: 'true' }
      assert_redirected_to admin_divisions_path
    end
  end

  test "update teams in a division (unsafe)" do
    assert @division.teams.any?{ |t| !t.allow_change? }

    team1 = @division.teams.first
    team2 = @division.teams.last

    params = {
      id: @division.id,
      team_ids: [team1.id, team2.id],
      seeds: [team2.seed, team1.seed]
    }

    put :update_teams, params: params

    assert_template 'admin/divisions/_unable_to_update_teams'
  end

  test "update teams in a division" do
    @teams = @division.teams.order(:seed)
    division = create_division(bracket_type: 'single_elimination_8')
    teams = @teams.to_a
    @teams.update_all(division_id: division.id)

    team1 = teams.first
    team2 = teams.last

    new_seed = 5
    refute_equal new_seed, team1.seed

    current_seed = team2.seed

    params = {
      id: division.id,
      team_ids: [team1.id, team2.id],
      seeds: [new_seed, current_seed]
    }

    put :update_teams, params: params
    assert_response :success

    assert_equal new_seed, team1.reload.seed
    assert_equal current_seed, team2.reload.seed
  end

  test "update teams in a division (ids not in order)" do
    @teams = @division.teams.order(:seed)
    division = create_division(bracket_type: 'single_elimination_8')
    teams = @teams.to_a
    @teams.update_all(division_id: division.id)

    team1 = teams.first
    team2 = teams.last

    new_seed = 5
    refute_equal new_seed, team1.seed

    current_seed = team2.seed

    params = {
      id: division.id,
      team_ids: [team2.id, team1.id],
      seeds: [current_seed, new_seed]
    }

    put :update_teams, params: params
    assert_response :success

    assert_equal new_seed, team1.reload.seed
    assert_equal current_seed, team2.reload.seed
  end

  test "seed a division" do
    @teams = @division.teams.order(:seed)
    division = create_division(bracket_type: 'single_elimination_8')
    @teams.update_all(division_id: division.id)

    post :seed, params: { id: division.id }
    assert_redirected_to admin_division_path(division)
    assert_equal 'Division seeded', flash[:notice]
  end

  test "seed a division with an error" do
    @teams = @division.teams.order(:seed)
    division = create_division(bracket_type: 'single_elimination_8')
    @teams.update_all(division_id: division.id)

    DivisionUpdate.perform(division, { bracket_type: 'single_elimination_4' }, 'true')

    post :seed, params: { id: division.id }
    assert_response :success
    assert_equal '4 seats but 8 teams present', flash[:error]
  end

  private

  def division_params
    {
      name: 'Junior Open',
      bracket_type: 'single_elimination_8'
    }
  end
end
