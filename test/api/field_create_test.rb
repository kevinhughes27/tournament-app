require 'test_helper'

class FieldCreateTest < ApiTest
  setup do
    login_user
    @output = '{ success, errors }'
  end

  test "create a field" do
    assert_difference "Field.count" do
      input = FactoryGirl.attributes_for(:field).except(:tournament)

      execute_graphql("fieldCreate", "FieldCreateInput", input, @output)

      assert_success
    end
  end

  test "create a field with errors" do
    input = FactoryGirl.attributes_for(:field, name: nil).except(:tournament)

    assert_no_difference "Field.count" do
      execute_graphql("fieldCreate", "FieldCreateInput", input, @output)
      assert_failure "Name can't be blank"
    end
  end
end
