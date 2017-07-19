require 'test_helper'

class Admin::TeamsControllerTest < ActionController::TestCase
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
    assert_not_nil assigns(:team)
  end

  test "get show" do
    team = FactoryGirl.create(:team)
    get :show, params: { id: team.id }
    assert_response :success
    assert_not_nil assigns(:team)
  end

  test "get index" do
    FactoryGirl.create(:team)
    get :index
    assert_response :success
    assert_not_nil assigns(:teams)
  end

  test "blank slate" do
    get :index
    assert_response :success
    assert_match 'blank-slate', response.body
  end

  test "create a team" do
    assert_difference "Team.count" do
      post :create, params: { team: new_team_params }

      team = assigns(:team)
      assert_redirected_to admin_team_path(team)
    end
  end

  test "create a team error re-renders form" do
    params = new_team_params
    params.delete(:name)

    assert_no_difference "Team.count" do
      post :create, params: { team: params }
      assert_template :new
    end
  end

  test "update a team" do
    team = FactoryGirl.create(:team)
    put :update, params: { id: team.id, team: safe_update_params }

    assert_redirected_to admin_team_path(team)
    assert_equal safe_update_params[:name], team.reload.name
  end

  test "update a team with errors" do
    team = FactoryGirl.create(:team)
    params = safe_update_params
    params[:name] = ''

    put :update, params: { id: team.id, team: params }

    assert_template :show
    assert_match "Name can&#39;t be blank", @response.body
    refute_equal safe_update_params[:name], team.reload.name
  end

  test "update a team with unsafe params" do
    division = FactoryGirl.create(:division)
    team = FactoryGirl.create(:team, division: division)
    FactoryGirl.create(:game, division: division, home: team)

    params = safe_update_params
    params[:seed] = 3

    put :update, params: { id: team.id, team: params }

    assert_response :unprocessable_entity
    assert_template 'admin/teams/_confirm_update'
  end

  test "confirm update a team with unsafe params" do
    division = FactoryGirl.create(:division)
    team = FactoryGirl.create(:team, division: division)
    FactoryGirl.create(:game, division: division, home: team)

    params = safe_update_params
    params[:seed] = 3

    put :update, params: { id: team.id, team: params, confirm: 'true' }

    assert_redirected_to admin_team_path(team)
    assert_equal 3, team.reload.seed
  end

  test "not allowed to update team with unsafe params" do
    division = FactoryGirl.create(:division)
    team = FactoryGirl.create(:team, division: division)
    FactoryGirl.create(:game, division: division, home: team)

    params = safe_update_params
    params[:seed] = 3

    put :update, params: { id: team.id, team: params }

    assert_template 'admin/teams/_unable_to_update'
  end

  test "delete a team" do
    team = FactoryGirl.create(:team)
    assert_difference "Team.count", -1 do
      delete :destroy, params: { id: team.id }
      assert_redirected_to admin_teams_path
    end
  end

  test "delete a team needs confirm if seeded but not scored" do
    division = FactoryGirl.create(:division)
    team = FactoryGirl.create(:team, division: division)
    FactoryGirl.create(:game, division: division, home: team)

    assert_no_difference "Team.count" do
      delete :destroy, params: { id: team.id }
      assert_response :unprocessable_entity
      assert_template 'admin/teams/_confirm_delete'
    end
  end

  test "confirm delete a team" do
    division = FactoryGirl.create(:division)
    team = FactoryGirl.create(:team, division: division)
    FactoryGirl.create(:game, division: division, home: team)

    assert_difference "Team.count", -1 do
      delete :destroy, params: { id: team.id, confirm: 'true' }
      assert_redirected_to admin_teams_path
    end
  end

  test "delete a team not allowed if division has any scores" do
    division = FactoryGirl.create(:division)
    team = FactoryGirl.create(:team, division: division)
    FactoryGirl.create(:game, :finished, division: division, home: team)

    assert_no_difference "Team.count" do
      delete :destroy, params: { id: team.id }
      assert_template 'admin/teams/_unable_to_delete'
    end
  end

  test "sample_csv returns a csv download" do
    get :sample_csv, format: :csv
    assert_match 'Name,Email,Phone,Division,Seed', response.body
  end

  test "import csv" do
    division = FactoryGirl.create(:division, name: 'Open')

    assert_difference "Team.count", +7 do
      post :import_csv, params: {
        csv_file: fixture_file_upload('files/teams.csv','text/csv'),
        match_behaviour: 'ignore'
      }
      assert_redirected_to admin_teams_path
      assert_equal 'Teams imported successfully', flash[:notice]
    end

    assert_equal division, Team.last.division
  end

  test "import csv (ignore matches)" do
    assert_difference "Team.count", +7 do
      post :import_csv, params: {
        csv_file: fixture_file_upload('files/teams.csv','text/csv'),
        match_behaviour: 'ignore'
      }
      assert_redirected_to admin_teams_path
      assert_equal 'Teams imported successfully', flash[:notice]
    end

    assert_no_difference "Team.count" do
      post :import_csv, params: {
        csv_file: fixture_file_upload('files/teams.csv','text/csv'),
        match_behaviour: 'ignore'
      }
      assert_redirected_to admin_teams_path
      assert_equal 'Teams imported successfully', flash[:notice]
    end
  end

  test "import csv (update matches)" do
    team = FactoryGirl.create(:team, name: 'SE7EN')

    assert_difference "Team.count", +6 do
      post :import_csv, params: {
        csv_file: fixture_file_upload('files/teams.csv','text/csv'),
        match_behaviour: 'update'
      }
      assert_redirected_to admin_teams_path
      assert_equal 'Teams imported successfully', flash[:notice]
    end
  end

  test "import csv with extra headings" do
    assert_difference "Team.count", +7 do
      post :import_csv, params: {
        csv_file: fixture_file_upload('files/teams-extra.csv','text/csv'),
        match_behaviour: 'ignore'
      }
      assert_redirected_to admin_teams_path
      assert_equal 'Teams imported successfully', flash[:notice]
    end
  end

  test "import csv with bad row data" do
    assert_no_difference "Team.count" do
      post :import_csv, params: {
        csv_file: fixture_file_upload('files/teams-bad-row.csv','text/csv'),
        match_behaviour: 'ignore'
      }
      assert_redirected_to admin_teams_path
      assert_equal "Row: 5 Validation failed: Name can't be blank", flash[:import_error]
    end
  end

  private

  def new_team_params
    {
      name: 'Goat',
      seed: 1
    }
  end

  def safe_update_params
    {
      name: 'Goat'
    }
  end
end
