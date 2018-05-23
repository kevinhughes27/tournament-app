require 'test_helper'

class UpdateMapTest < ApiTest
  setup do
    login_user
    @output = '{ success }'
  end

  test "update map" do
    map = FactoryGirl.create(:map)
    input = FactoryGirl.attributes_for(:map).except(:tournament)

    execute_graphql("updateMap", "UpdateMapInput", input, @output)

    assert_success
    assert_equal input[:lat], map.reload.lat
  end
end