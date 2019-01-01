require 'test_helper'

class UpdateMapTest < ApiTest
  setup do
    login_user
    @output = '{ success }'
  end

  test "queries" do
    map = FactoryBot.create(:map)
    input = FactoryBot.attributes_for(:map).except(:tournament)

    assert_queries(7) do
      execute_graphql("updateMap", "UpdateMapInput", input, @output)
      assert_success
    end
  end

  test "update map" do
    map = FactoryBot.create(:map)
    input = FactoryBot.attributes_for(:map).except(:tournament)

    execute_graphql("updateMap", "UpdateMapInput", input, @output)

    assert_success
    assert_equal input[:lat], map.reload.lat
  end
end
