require 'test_helper'

class FieldUpdateTest < ApiTest
  setup do
    login_user
    @output = '{ success, errors }'
  end

  test "update a field" do
    field = FactoryGirl.create(:field)
    attributes = FactoryGirl.attributes_for(:field).except(:tournament)
    input = {field_id: field.id, **attributes}

    execute_graphql("fieldUpdate", "FieldUpdateInput", input, @output)

    assert_success
    assert_equal attributes[:name], field.reload.name
  end

  test "update a field with errors" do
    field = FactoryGirl.create(:field)
    attributes = FactoryGirl.attributes_for(:field, name: nil).except(:tournament)
    input = {field_id: field.id, **attributes}

    execute_graphql("fieldUpdate", "FieldUpdateInput", input, @output)
    assert_failure "Name can't be blank"
  end
end
