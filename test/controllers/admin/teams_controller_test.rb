require 'test_helper'

class Admin::TeamsControllerTest < AdminControllerTest
  test "get new" do
    get :new
    assert_response :success
  end

  test "get show" do
    team = FactoryBot.create(:team)
    get :show, params: { id: team.id }
    assert_response :success
  end

  test "get spirit" do
    team = FactoryBot.create(:team)
    game = FactoryBot.create(:game, away: team)
    FactoryBot.create(:score_report, game: game, team: game.home, comments: 'foobar')
    get :spirit_scores, params: { id: team.id }
    assert_response :success
    assert_match 'foobar', response.body
  end

  test "get index" do
    FactoryBot.create(:team)
    get :index
    assert_response :success
  end

  test "blank slate" do
    get :index
    assert_response :success
    assert_match 'blank-slate', response.body
  end

  test "create a team" do
    assert_difference "Team.count" do
      post :create, params: { team: FactoryBot.attributes_for(:team) }

      team = Team.last
      assert_redirected_to admin_team_path(team)
    end
  end

  test "create a team error re-renders form" do
    params = FactoryBot.attributes_for(:team, name: nil)

    assert_no_difference "Team.count" do
      post :create, params: { team: params }
    end
  end

  test "update a team" do
    team = FactoryBot.create(:team)
    attributes = FactoryBot.attributes_for(:team).except(:division)
    put :update, params: { id: team.id, team: attributes }

    assert_redirected_to admin_team_path(team)
    assert_equal attributes[:name], team.reload.name
  end

  # this is a tricky case while we are moving to graphql but still have rails controllers and strong params
  test "update a team with numeric phone number" do
    team = FactoryBot.create(:team)
    attributes = FactoryBot.attributes_for(:team, phone: '15555555555').except(:division)

    put :update, params: { id: team.id, team: attributes }

    assert_redirected_to admin_team_path(team)
    assert_equal attributes[:phone], team.reload.phone
  end

  test "update a team with errors" do
    team = FactoryBot.create(:team)

    params = { name: '' }
    put :update, params: { id: team.id, team: params }

    assert_match "Name can&#39;t be blank", @response.body
  end

  test "update a team with unsafe params" do
    team = FactoryBot.create(:team, seed: 2)
    FactoryBot.create(:game, home: team)

    params = { seed: 3 }
    put :update, params: { id: team.id, team: params }

    assert_response :unprocessable_entity
    assert_match "Confirm Change", response.body
  end

  test "confirm update a team with unsafe params" do
    team = FactoryBot.create(:team, seed: 2)
    FactoryBot.create(:game, home: team)

    params = { seed: 3 }
    put :update, params: { id: team.id, team: params, confirm: 'true' }

    assert_redirected_to admin_team_path(team)
    assert_equal 3, team.reload.seed
  end

  test "not allowed to update team with unsafe params" do
    team = FactoryBot.create(:team, seed: 2)
    FactoryBot.create(:game, :finished, home: team)

    params = { seed: 3 }
    put :update, params: { id: team.id, team: params }

    assert_match "Unable to Update", response.body
  end

  test "delete a team" do
    team = FactoryBot.create(:team)
    assert_difference "Team.count", -1 do
      delete :destroy, params: { id: team.id }
      assert_redirected_to admin_teams_path
    end
  end

  test "delete a team needs confirm if seeded but not scored" do
    division = FactoryBot.create(:division)
    team = FactoryBot.create(:team, division: division)
    FactoryBot.create(:game, division: division, home: team)

    assert_no_difference "Team.count" do
      delete :destroy, params: { id: team.id }
      assert_response :unprocessable_entity
      assert_match "Confirm Deletion", response.body
    end
  end

  test "confirm delete a team" do
    division = FactoryBot.create(:division)
    team = FactoryBot.create(:team, division: division)
    FactoryBot.create(:game, division: division, home: team)

    assert_difference "Team.count", -1 do
      delete :destroy, params: { id: team.id, confirm: 'true' }
      assert_redirected_to admin_teams_path
    end
  end

  test "delete a team not allowed if division has any scores" do
    division = FactoryBot.create(:division)
    team = FactoryBot.create(:team, division: division)
    FactoryBot.create(:game, :finished, division: division, home: team)

    assert_no_difference "Team.count" do
      delete :destroy, params: { id: team.id }
      assert_match "Unable to Delete", response.body
    end
  end

  test "sample_csv returns a csv download" do
    get :sample_csv, format: :csv
    assert_match 'Name,Email,Phone,Division,Seed', response.body
  end

  test "import csv" do
    division = FactoryBot.create(:division, name: 'Open')

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
    team = FactoryBot.create(:team, name: 'SE7EN')

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

  test "assigns teams to a division" do
    team = FactoryBot.create(:team)
    new_division = FactoryBot.create(:division)

    put :set_division, params: {
      ids: [team.id],
      arg: new_division.name
    }

    assert_response :success
    assert_equal team.reload.name, response_json.first["name"]
    assert_equal new_division.name, response_json.first["division"]
    assert_equal new_division, team.division
  end
end
