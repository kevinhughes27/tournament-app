require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)
  end

  protected

  def login_user(user = nil)
    user ||= @user

    url = "http://#{@tournament.handle}.lvh.me/user_token"

    post url, params: { auth: {email: user.email, password: user.password} }
    assert_equal 201, status

    jwt = JSON.parse(response.body)['jwt']
    @authenticated_header = {'Authorization' => "Bearer #{jwt}"}
  end

  # filter is default true since fields are only hidden not protected
  def query_graphql(query, variables: {}, filter: true, expect_error: nil)
    url = "http://#{@tournament.handle}.lvh.me/graphql"

    params = {
      "query" => query,
      "variables" => variables,
      "filter" => filter
    }

    post url, params: params.to_json, headers: headers

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

    post url, params: params.to_json, headers: headers
    assert_equal 200, response.status
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
    assert_equal message, mutation_result['message']
  end

  def assert_failure(expectation = nil)
    refute mutation_result['success']

    if expectation.is_a?(Hash)
      expectation = expectation.is_a?(Array) ? expectation : [expectation]
      assert_equal expectation, mutation_result['userErrors']
    elsif expectation
      assert_equal expectation, mutation_result['message']
    end
  end

  private

  def headers
    @headers = { 'CONTENT_TYPE' => 'application/json' }
    @headers.merge!(@authenticated_header) if @authenticated_header
    @headers
  end

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
