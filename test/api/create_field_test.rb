require 'test_helper'

class CreateFieldTest < ApiTest
  setup do
    login_user
    @output = '{ success userErrors { field message } }'
  end

  test "create a field" do
    assert_difference "Field.count" do
      input = FactoryBot.attributes_for(:field).except(:tournament)

      execute_graphql("createField", "CreateFieldInput", input, @output)

      assert_success
    end
  end

  test "create a field with errors" do
    input = FactoryBot.attributes_for(:field, name: nil).except(:tournament)

    assert_no_difference "Field.count" do
      execute_graphql("createField", "CreateFieldInput", input, @output)
      assert_failure({ 'field' => 'name', 'message' => "can't be blank" })
    end
  end
end
