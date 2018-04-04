require 'test_helper'

class ApiAuthTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryGirl.create(:user)
    @tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:tournament_user, user: @user, tournament: @tournament)
    ReactOnRails::TestHelper.ensure_assets_compiled
  end

  test "mutation with auth" do
    login_user
    game = FactoryGirl.create(:game, :scheduled)
    input = {"game_id" => game.id, "home_score" => 10, "away_score" => 5}
    result = execute_graphql("gameUpdateScore", "GameUpdateScoreInput", input)
    assert result["data"]["gameUpdateScore"]["success"]
  end

  test "mutation without auth" do
    game = FactoryGirl.create(:game, :scheduled)
    input = {"game_id" => game.id, "home_score" => 10, "away_score" => 5}
    result = execute_graphql("gameUpdateScore", "GameUpdateScoreInput", input)
    assert_equal "Field 'gameUpdateScore' doesn't exist on type 'Mutation'", result['errors'].first['message']
    # assert_equal "You need to sign in or sign up before continuing", result['errors'].first['message']
  end

  test "mutation with auth for wrong tournament" do
    login_user
    @tournament = FactoryGirl.create(:tournament)
    game = FactoryGirl.create(:game, :scheduled, tournament: @tournament)
    input = {"game_id" => game.id, "home_score" => 10, "away_score" => 5}
    result = execute_graphql("gameUpdateScore", "GameUpdateScoreInput", input)
    assert_equal "Field 'gameUpdateScore' doesn't exist on type 'Mutation'", result['errors'].first['message']
    # assert_equal "You are not a registered user for this tournament", result['errors'].first['message']
  end

  private

  def login_user
    get "http://#{@tournament.handle}.lvh.me/admin"
    follow_redirect!
    assert_equal 200, status
    assert_equal new_user_session_path, path

    post new_user_session_path, params: { user: {email: @user.email, password: 'password'} }
    follow_redirect!
    assert_equal 200, status
    assert_equal "/admin", path
  end

  def execute_graphql(mutation, input_type, input)
    url = "http://#{@tournament.handle}.lvh.me/graphql"

    params = {
      "query" => "mutation #{mutation}($input: #{input_type}!) { #{mutation}(input: $input) { success }}",
      "variables" => {"input" => input}
    }

    post url, params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }

    JSON.parse(response.body)
  end
end
