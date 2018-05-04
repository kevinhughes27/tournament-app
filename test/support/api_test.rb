require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryGirl.create(:user)
    @tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:tournament_user, user: @user, tournament: @tournament)
    ReactOnRails::TestHelper.ensure_assets_compiled
  end

  protected

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

  def execute_graphql(mutation, input_type, input, output = '{ success }', filter: false)
    url = "http://#{@tournament.handle}.lvh.me/graphql"

    params = {
      "query" => "mutation #{mutation}($input: #{input_type}!) { #{mutation}(input: $input) #{output} }",
      "variables" => {"input" => input},
      "filter" => filter
    }

    post url, params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }

    @result = JSON.parse(response.body)
    # assert the query was valid here
  end

  def assert_success
    assert mutation_result['success']
  end

  def assert_confirmation_required(message)
    refute mutation_result['success']
    assert mutation_result['confirm']
    assert_equal message, mutation_result['errors'].first
  end

  def assert_failure(expected_errors = nil)
    refute mutation_result['success']
    assert_equal Array(expected_errors), mutation_result['errors'] if expected_errors
  end

  def assert_error(message)
    assert_equal message, @result['errors'].first['message']
  end

  def mutation_result
     @result['data'].first[1]
  end
end