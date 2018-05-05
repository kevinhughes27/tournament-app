require 'test_helper'

class TeamTypeTest < ApiTest
  test "private fields are hidden to the public" do
    team = FactoryGirl.create(:team)

    query_graphql("
      teams {
      	name
        email
      }
    ")

    assert_error "Field 'email' doesn't exist on type 'Team'"
  end

  test "private fields require auth" do
    login_user
    team = FactoryGirl.create(:team)

    query_graphql("
      teams {
      	name
        email
      }
    ")

    assert_equal team.email, query_result['teams'].first['email']
  end
end
