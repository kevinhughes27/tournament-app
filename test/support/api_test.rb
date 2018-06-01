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

  # filter is default true since fields are only hidden not protected
  def query_graphql(query, filter: true, expect_error: nil)
    url = "http://#{@tournament.handle}.lvh.me/graphql"

    params = {
      "query" => "query { #{query} } ",
      "filter" => filter
    }

    post url, params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }

    @result = JSON.parse(response.body)

    if expect_error
      assert_error expect_error
    else
      assert_error_free
    end
  end

  # filter is default false to ensure that mutations are protected and hidden
  def execute_graphql(mutation, input_type, input, output = '{ success }', filter: false, expect_error: nil)
    url = "http://#{@tournament.handle}.lvh.me/graphql"

    params = {
      "query" => "mutation #{mutation}($input: #{input_type}!) { #{mutation}(input: $input) #{output} }",
      "variables" => {"input" => input.deep_transform_keys { |key| key.to_s.camelize(:lower) }},
      "filter" => filter
    }

    post url, params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }

    @result = JSON.parse(response.body)

    if expect_error
      assert_error expect_error
    else
      assert_error_free
    end
  end

  def assert_success
    assert mutation_result['success']
  end

  def assert_confirmation_required(message)
    refute mutation_result['success']
    assert mutation_result['confirm']
    assert_equal message, mutation_result['userErrors'].first
  end

  def assert_failure(expected_errors = nil)
    refute mutation_result['success']
    assert_equal Array(expected_errors), mutation_result['userErrors'] if expected_errors
  end

  private

  def assert_error_free
    assert_nil @result['errors'], 'GraphQL Errors'
  end

  def assert_error(message)
    assert_equal message, @result['errors'].first['message']
  end

  def mutation_result
    @result['data'].first[1]
  end

  def query_result
    @result['data']
  end
end
