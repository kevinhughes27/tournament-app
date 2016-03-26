require 'test_helper'

class Admin::TeamsControllerTest < ActionController::TestCase

  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)

    @team = teams(:swift)
    @division = divisions(:open)
    sign_in users(:kevin)
  end

  test "get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:team)
  end

  test "get show" do
    get :show, id: @team.id
    assert_response :success
    assert_not_nil assigns(:team)
  end

  test "get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:teams)
  end

  test "blank slate" do
    @tournament.teams.destroy_all
    get :index
    assert_response :success
    assert_match 'blank-slate', response.body
  end

  test "create a team" do
    assert_difference "Team.count" do
      post :create, team: new_team_params

      team = assigns(:team)
      assert_redirected_to admin_team_path(team)
    end
  end

  test "create a team error re-renders form" do
    params = new_team_params
    params.delete(:name)

    assert_no_difference "Team.count" do
      post :create, team: params
      assert_template :new
    end
  end

  test "update a team" do
    put :update, id: @team.id, team: safe_update_params

    assert_redirected_to admin_team_path(@team)
    assert_equal safe_update_params[:name], @team.reload.name
  end

  test "update a team with errors" do
    params = safe_update_params
    params[:name] = ''

    put :update, id: @team.id, team: params

    assert_template :show
    refute_equal safe_update_params[:name], @team.reload.name
  end

  test "update a team with unsafe params" do
    @division.games.update_all(score_confirmed: false)

    params = safe_update_params
    params[:seed] = 3

    put :update, id: @team.id, team: params

    assert_response :unprocessable_entity
    assert_template 'admin/teams/_confirm_update'
  end

  test "confirm update a team with unsafe params" do
    @division.games.update_all(score_confirmed: false)

    params = safe_update_params
    params[:seed] = 3

    put :update, id: @team.id, team: params, confirm: 'true'

    assert_redirected_to admin_team_path(@team)
    assert_equal 3, @team.reload.seed
  end

  test "not allowed to update team with unsafe params" do
    params = safe_update_params
    params[:seed] = 3

    put :update, id: @team.id, team: params

    assert_template 'admin/teams/_unable_to_update'
  end

  test "delete a team" do
    team = teams(:stella)
    assert_difference "Team.count", -1 do
      delete :destroy, id: team.id
      assert_redirected_to admin_teams_path
    end
  end

  test "delete a team needs confirm if seeded but not scored" do
    @division.games.update_all(score_confirmed: false)

    assert_no_difference "Team.count" do
      delete :destroy, id: @team.id
      assert_response :unprocessable_entity
      assert_template 'admin/teams/_confirm_delete'
    end
  end

  test "confirm delete a team" do
    @division.games.update_all(score_confirmed: false)

    assert_difference "Team.count", -1 do
      delete :destroy, id: @team.id, confirm: 'true'
      assert_redirected_to admin_teams_path
    end
  end

  test "delete a team not allowed if division has any scores" do
    assert_no_difference "Team.count" do
      delete :destroy, id: @team.id
      assert_template 'admin/teams/_unable_to_delete'
    end
  end

  test "sample_csv returns a csv download" do
    get :sample_csv, format: :csv
    assert_match 'Name,Division,Seed', response.body
  end

  test "import csv" do
    assert_difference "Team.count", +7 do
      post :import_csv, csv_file: fixture_file_upload('files/teams.csv','text/csv'), match_behaviour: 'ignore'
    end

    assert_equal @division, Team.last.division
  end

  test "import csv (ignore matches)" do
    assert_difference "Team.count", +7 do
      post :import_csv, csv_file: fixture_file_upload('files/teams.csv','text/csv'), match_behaviour: 'ignore'
    end

    assert_no_difference "Team.count" do
      post :import_csv, csv_file: fixture_file_upload('files/teams.csv','text/csv'), match_behaviour: 'ignore'
    end
  end

  test "import csv (update matches)" do
    @team.update_attributes(name: 'SE7EN')

    assert_difference "Team.count", +6 do
      post :import_csv, csv_file: fixture_file_upload('files/teams.csv','text/csv'), match_behaviour: 'update'
    end
  end

  test "import csv with extra headings" do
    assert_difference "Team.count", +7 do
      post :import_csv, csv_file: fixture_file_upload('files/teams-extra.csv','text/csv'), match_behaviour: 'ignore'
    end
  end

  test "import csv with bad row data" do
    assert_no_difference "Team.count" do
      post :import_csv, csv_file: fixture_file_upload('files/teams-bad-row.csv','text/csv'), match_behaviour: 'ignore'
      # assert that some sort of error is shown or flashed
    end
  end

  private

  def new_team_params
    {
      name: 'Goat',
      division_id: @division.id,
      seed: 1
    }
  end

  def safe_update_params
    {
      name: 'Goat'
    }
  end
end
