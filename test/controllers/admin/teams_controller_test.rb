require 'test_helper'

class Admin::TeamsControllerTest < ActionController::TestCase

  setup do
    @tournament = tournaments(:noborders)
    @team = teams(:swift)
    @division = divisions(:open)
    sign_in users(:kevin)
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

  test "blank slate" do
    @tournament.teams.destroy_all
    get :index, tournament_id: @tournament.id
    assert_response :success
    assert_match 'blank-slate', response.body
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
    team = teams(:shrike)
    assert_difference "Team.count", -1 do
      delete :destroy, id: team.id, tournament_id: @tournament.id
      assert_redirected_to tournament_admin_teams_path(@tournament)
    end
  end

  test "delete a team needs confirm if seeded but not scored" do
    @division.games.update_all(score_confirmed: false)

    assert_no_difference "Team.count" do
      delete :destroy, id: @team.id, tournament_id: @tournament.id
      assert_response :unprocessable_entity
      assert_template 'admin/teams/_confirm_delete'
    end
  end

  test "confirm delete a team" do
    @division.games.update_all(score_confirmed: false)

    assert_difference "Team.count", -1 do
      delete :destroy, id: @team.id, tournament_id: @tournament.id, confirm: 'true'
      assert_redirected_to tournament_admin_teams_path(@tournament)
    end
  end

  test "delete a team not allowed if division has any scores" do
    assert_no_difference "Team.count" do
      delete :destroy, id: @team.id, tournament_id: @tournament.id
      assert_template 'admin/teams/_unable_to_delete'
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

    assert_equal @division, Team.last.division
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
      division_id: @division.id,
      seed: 1
    }
  end

end
