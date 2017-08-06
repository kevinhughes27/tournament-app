require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  setup do
    @tournament = FactoryGirl.create(:tournament)
    host! "#{@tournament.handle}.ut-test.io"
  end

  test "fetch teams" do
    team = FactoryGirl.create(:team)

    get api_teams_path

    assert_equal team.name, response_json.first['name']
  end

  test "fetch fields" do
    field = FactoryGirl.create(:field)

    get api_fields_path

    assert_equal field.name, response_json.first['name']
  end

  test "fetch games" do
    game = FactoryGirl.create(:game)

    get api_games_path

    assert_equal game.bracket_uid, response_json.first['bracket_uid']
  end
end
