require 'test_helper'

class Admin::DivisionsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:tournament_user, user: @user, tournament: @tournament)
    set_tournament(@tournament)
    sign_in @user
  end

  test "get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:division)
  end

  test "get show" do
    division = FactoryGirl.create(:division)
    get :show, params: { id: division.id }
    assert_response :success
    assert_not_nil assigns(:division)
  end

  test "get edit" do
    division = FactoryGirl.create(:division)
    get :edit, params: { id: division.id }
    assert_response :success
    assert_not_nil assigns(:division)
  end

  test "get index" do
    division = FactoryGirl.create(:division)
    get :index
    assert_response :success
  end

  test "blank slate" do
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
    division = FactoryGirl.create(:division)
    put :update, params: { id: division.id, division: division_params }

    assert_redirected_to admin_division_path(division)
    assert_equal division_params[:name], division.reload.name
  end

  test "update a division (unsafe)" do
    division = FactoryGirl.create(:division)
    game = FactoryGirl.create(:game, :finished, division: division)

    params = division_params.merge(bracket_type: 'single_elimination_4')
    put :update, params: { id: division.id, division: params }

    assert_response :unprocessable_entity
    assert_template 'admin/divisions/_confirm_update'
  end

  test "update a division (unsafe) + confirm" do
    division = FactoryGirl.create(:division)
    params = division_params.merge(bracket_type: 'single_elimination_4')
    put :update, params: { id: division.id, division: params, confirm: 'true' }

    assert_redirected_to admin_division_path(division)
    assert_equal params[:bracket_type], division.reload.bracket_type
  end

  test "update a division with errors" do
    division = FactoryGirl.create(:division)
    params = division_params
    params.delete(:name)

    put :update, params: { id: division.id, division: params }

    assert_redirected_to admin_division_path(division)
    refute_equal division_params[:name], division.reload.name
  end

  test "delete a division" do
    division = FactoryGirl.create(:division)
    assert_difference "Division.count", -1 do
      delete :destroy, params: { id: division.id }
      assert_redirected_to admin_divisions_path
    end
  end

  test "unsafe delete a division needs confirm" do
    division = FactoryGirl.create(:division)
    game = FactoryGirl.create(:game, :finished, division: division)

    assert_no_difference "Division.count" do
      delete :destroy, params: { id: division.id }
      assert_response :unprocessable_entity
      assert_template 'admin/divisions/_confirm_delete'
    end
  end

  test "confirm delete a division" do
    division = FactoryGirl.create(:division)
    game = FactoryGirl.create(:game, :finished, division: division)

    assert_difference "Division.count", -1 do
      delete :destroy, params: { id: division.id, confirm: 'true' }
      assert_redirected_to admin_divisions_path
    end
  end

  test "update teams and seed" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_4')
    division = build_division(@tournament, params)

    teams = (1..4).map do |seed|
      FactoryGirl.create(:team, division: division, seed: seed)
    end

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

    post :seed, params: params
    assert_response :success

    assert_equal new_seed, team1.reload.seed
    assert_equal current_seed, team2.reload.seed
    refute division.seeded?
  end

  test "update teams and seed (ids not in order)" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_4')
    division = build_division(@tournament, params)

    teams = (1..4).map do |seed|
      FactoryGirl.create(:team, division: division, seed: seed)
    end

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

    post :seed, params: params
    assert_response :success

    assert_equal new_seed, team1.reload.seed
    assert_equal current_seed, team2.reload.seed
    refute division.seeded?
  end

  test "seed a division" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_4')
    division = build_division(@tournament, params)

    teams = (1..4).map do |seed|
      FactoryGirl.create(:team, division: division, seed: seed)
    end

    post :seed, params: { id: division.id }
    assert_redirected_to admin_division_path(division)
    assert_equal 'Division seeded', flash[:notice]
  end

  test "seed (unsafe)" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_4')
    division = build_division(@tournament, params)

    teams = (1..4).map do |seed|
      FactoryGirl.create(:team, division: division, seed: seed)
    end

    FactoryGirl.create(:game, :finished, division: division, home: teams.first)

    assert division.teams.any?{ |t| !t.allow_change? }

    team1 = division.teams.first
    team2 = division.teams.last

    params = {
      id: division.id,
      team_ids: [team1.id, team2.id],
      seeds: [team2.seed, team1.seed]
    }

    post :seed, params: params

    assert_template 'admin/divisions/_confirm_seed'
  end

  test "seed a division with an error" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_4')
    division = build_division(@tournament, params)

    teams = (1..8).map do |seed|
      FactoryGirl.create(:team, division: division, seed: seed)
    end

    post :seed, params: { id: division.id }
    assert_response :success
    assert_equal '4 seats but 8 teams present', flash[:seed_error]
  end

  private

  def division_params
    {
      name: 'Junior Open',
      bracket_type: 'single_elimination_8'
    }
  end
end
