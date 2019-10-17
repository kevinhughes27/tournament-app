require 'test_helper'

class OperationTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)
  end

  def execute_graphql(mutation, input_type, input)
    query_string = """
      mutation #{mutation}($input: #{input_type}!) {
        #{mutation}(input: $input) {
          success
          message
        }
      }
      """

    query_variables = {
      "input" => input.deep_transform_keys { |key| key.to_s.camelize(:lower) }
    }

    result = Schema.execute(
      query_string,
      variables: query_variables,
      context: {
        tournament: @tournament,
        current_user: @user
      }
    )

    assert_nil result['errors'], "GraphQL Error: #{result['errors']}"
    assert result['data'][mutation]['success'], "Graphql Failed: #{result['data'][mutation]}"
  end
end
