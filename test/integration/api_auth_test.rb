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
    execute_graphql("gameUpdateScore", "GameUpdateScoreInput", input)
    assert_success
  end

  test "mutation without auth" do
    game = FactoryGirl.create(:game, :scheduled)
    input = {"game_id" => game.id, "home_score" => 10, "away_score" => 5}
    execute_graphql("gameUpdateScore", "GameUpdateScoreInput", input)
    assert_error "You need to sign in or sign up before continuing"
  end

  test "mutation with auth for wrong tournament" do
    login_user
    @tournament = FactoryGirl.create(:tournament)
    game = FactoryGirl.create(:game, :scheduled, tournament: @tournament)
    input = {"game_id" => game.id, "home_score" => 10, "away_score" => 5}
    execute_graphql("gameUpdateScore", "GameUpdateScoreInput", input)
    assert_error "You are not a registered user for this tournament"
  end

  test "mutation without auth with filter" do
    game = FactoryGirl.create(:game, :scheduled)
    input = {"game_id" => game.id, "home_score" => 10, "away_score" => 5}
    execute_graphql("gameUpdateScore", "GameUpdateScoreInput", input, filter: true)
    assert_error "Field 'gameUpdateScore' doesn't exist on type 'Mutation'"
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

  def execute_graphql(mutation, input_type, input, filter: false)
    url = "http://#{@tournament.handle}.lvh.me/graphql"

    params = {
      "query" => "mutation #{mutation}($input: #{input_type}!) { #{mutation}(input: $input) { success }}",
      "variables" => {"input" => input},
      "filter" => filter
    }

    post url, params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }

    @result = JSON.parse(response.body)
  end

  def assert_success
    assert @result['data'].first[1]['success']
  end

  def assert_error(message)
    assert_equal message, @result['errors'].first['message']
  end
end
