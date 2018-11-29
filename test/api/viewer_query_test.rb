require 'test_helper'

class ViewerQueryTest < ApiTest
  test "viewer is null" do
    viewer = FactoryBot.create(:user)

    query_graphql("
      viewer {
      	name
        email
      }",
    )

    assert_nil query_result["viewer"]
  end

  test "email field is present for authenticated requests" do
    viewer = FactoryBot.create(:user)
    login_user(viewer)

    query_graphql("
      viewer {
      	name
        email
      }"
    )

    assert_equal viewer.email,  query_result['viewer']['email']
  end
end
