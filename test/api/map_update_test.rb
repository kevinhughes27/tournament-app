require 'test_helper'

class MapUpdateTest < ApiTest
  setup do
    login_user
    @output = '{ success }'
  end

  test "update map" do
    map = FactoryGirl.create(:map)
    input = FactoryGirl.attributes_for(:map).except(:tournament)

    execute_graphql("mapUpdate", "MapUpdateInput", input, @output)

    assert_success
    assert_equal input[:lat], map.reload.lat
  end
end
