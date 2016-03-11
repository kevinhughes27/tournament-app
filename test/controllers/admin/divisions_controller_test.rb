require 'test_helper'

class Admin::DivisionsControllerTest < ActionController::TestCase

  setup do
    @tournament = tournaments(:noborders)
    @division = divisions(:open)
    sign_in users(:kevin)
  end

  test "get new" do
    get :new, tournament_id: @tournament.id
    assert_response :success
    assert_not_nil assigns(:division)
  end

  test "get show" do
    get :show, id: @division.id, tournament_id: @tournament.id
    assert_response :success
    assert_not_nil assigns(:division)
  end

  test "get index" do
    get :index, tournament_id: @tournament.id
    assert_response :success
  end

  test "blank slate" do
    @tournament.divisions.destroy_all
    get :index, tournament_id: @tournament.id
    assert_response :success
    assert_match 'blank-slate', response.body
  end

  test "create a division" do
    assert_difference "Division.count" do
      post :create, tournament_id: @tournament.id, division: division_params

      division = assigns(:division)
      assert_redirected_to tournament_admin_division_path(@tournament, division)
    end
  end

  test "create a division error re-renders form zzz" do
    params = division_params
    params.delete(:name)

    assert_no_difference "Division.count" do
      post :create, tournament_id: @tournament.id, division: params
      assert_template :new
    end
  end

  test "update a division" do
    put :update, id: @division.id, tournament_id: @tournament.id, division: division_params

    assert_redirected_to tournament_admin_division_path(@tournament, @division)
    assert_equal division_params[:name], @division.reload.name
  end

  test "update a division with errors" do
    params = division_params
    params.delete(:name)

    put :update, id: @division.id, tournament_id: @tournament.id, division: params

    assert_redirected_to tournament_admin_division_path(@tournament, @division)
    refute_equal division_params[:name], @division.reload.name
  end

  test "delete a division" do
    division = divisions(:women)
    assert_difference "Division.count", -1 do
      delete :destroy, id: division.id, tournament_id: @tournament.id
      assert_redirected_to tournament_admin_divisions_path(@tournament)
    end
  end

  test "delete a division needs confirm" do
    assert_no_difference "Division.count" do
      delete :destroy, id: @division.id, tournament_id: @tournament.id
      assert_response :unprocessable_entity
      assert_template 'admin/divisions/_confirm_delete'
    end
  end

  test "confirm delete a division" do
    assert_difference "Division.count", -1 do
      delete :destroy, id: @division.id, tournament_id: @tournament.id, confirm: 'true'
      assert_redirected_to tournament_admin_divisions_path(@tournament)
    end
  end

  test "update teams in a division" do
    team1 = @division.teams.first
    team2 = @division.teams.last

    new_seed = 5
    refute_equal new_seed, team1.seed

    current_seed = team2.seed

    params = {
      id: @division.id,
      tournament_id: @tournament.id,
      team_ids: [team1.id, team2.id],
      seeds: [new_seed, current_seed]
    }

    put :update_teams, params
    assert_response :success

    assert_equal new_seed, team1.reload.seed
    assert_equal current_seed, team2.reload.seed
  end

  test "seed a division" do
    # hack to get all the games created
    @division.update_attribute(:bracket_type, 'single_elimination_4')
    @division.update_attribute(:bracket_type, 'single_elimination_8')

    put :seed, id: @division.id, tournament_id: @tournament.id
    assert_response :success
    assert_equal 'Division seeded', flash[:notice]
  end

  test "seed a division with an error" do
    @division.update_attribute(:bracket_type, 'single_elimination_4')

    put :seed, id: @division.id, tournament_id: @tournament.id
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
