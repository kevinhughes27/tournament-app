require 'test_helper'

class Admin::TeamsControllerTest < ActionController::TestCase

  setup do
    http_login('admin', 'nobo')
    @tournament = tournaments(:noborders)
    @team = teams(:swift)
  end

  test "get new" do
    get :new, tournament_id: @tournament.id
    assert_response :success
    assert_not_nil assigns(:team)
  end

  test "get show" do
    get :show, id: @team.id, tournament_id: @tournament.id
    assert_response :success
    assert_not_nil assigns(:team)
  end

  test "get index" do
    get :index, tournament_id: @tournament.id
    assert_response :success
    assert_not_nil assigns(:teams)
  end

  test "create a team" do
    assert_difference "Team.count" do
      post :create, tournament_id: @tournament.id, team: team_params

      team = assigns(:team)
      assert_redirected_to tournament_admin_team_path(@tournament, team)
    end
  end

  test "create a team error re-renders form" do
    params = team_params
    params.delete(:name)

    assert_no_difference "Team.count" do
      post :create, tournament_id: @tournament.id, team: params
      assert_template :new
    end
  end

  test "update a team" do
    put :update, id: @team.id, tournament_id: @tournament.id, team: team_params

    assert_redirected_to tournament_admin_team_path(@tournament, @team)
    assert_equal team_params[:name], @team.reload.name
  end

  test "update a team with errors" do
    params = team_params
    params.delete(:name)

    put :update, id: @team.id, tournament_id: @tournament.id, team: params

    assert_redirected_to tournament_admin_team_path(@tournament, @team)
    refute_equal team_params[:name], @team.reload.name
  end

  test "delete a team" do
    assert_difference "Team.count", -1 do
      delete :destroy, id: @team.id, tournament_id: @tournament.id
      assert_redirected_to tournament_admin_teams_path(@tournament)
    end
  end


  test "sample_csv returns a csv download" do
    get :sample_csv, tournament_id: @tournament.id, format: :csv
    assert_match 'Name,Division,Seed', response.body
  end

  test "import csv" do
    assert_difference "Team.count", +7 do
      post :import_csv, tournament_id: @tournament.id,
        csv_file: fixture_file_upload('files/teams.csv','text/csv'),
        match_behaviour: 'ignore'
    end
  end

  test "import csv (ignore matches)" do
    assert_difference "Team.count", +7 do
      post :import_csv, tournament_id: @tournament.id,
        csv_file: fixture_file_upload('files/teams.csv','text/csv'),
        match_behaviour: 'ignore'
    end

    assert_no_difference "Team.count" do
      post :import_csv, tournament_id: @tournament.id,
        csv_file: fixture_file_upload('files/teams.csv','text/csv'),
        match_behaviour: 'ignore'
    end
  end

  test "import csv (update matches)" do
    @team.update_attributes(name: 'SE7EN')

    assert_difference "Team.count", +6 do
      post :import_csv, tournament_id: @tournament.id,
        csv_file: fixture_file_upload('files/teams.csv','text/csv'),
        match_behaviour: 'update'
    end
  end

  test "import csv with extra headings" do
    assert_difference "Team.count", +7 do
      post :import_csv, tournament_id: @tournament.id,
        csv_file: fixture_file_upload('files/teams-extra.csv','text/csv'),
        match_behaviour: 'ignore'
    end
  end

  test "import csv with bad row data" do
    assert_no_difference "Team.count" do
      post :import_csv, tournament_id: @tournament.id,
        csv_file: fixture_file_upload('files/teams-bad-row.csv','text/csv'),
        match_behaviour: 'ignore'
      # assert that some sort of error is shown or flashed
    end
  end

  private

  def team_params
    {
      name: 'Goat',
      division: 'Open',
      seed: 1
    }
  end

end
