require 'test_helper'

class UpdateFieldTest < ApiTest
  setup do
    login_user
    @output = '{ success userErrors { field message } }'
  end

  test "update a field" do
    field = FactoryBot.create(:field)
    attributes = FactoryBot.attributes_for(:field).except(:tournament)
    input = {field_id: field.id, **attributes}

    execute_graphql("updateField", "UpdateFieldInput", input, @output)

    assert_success
    assert_equal attributes[:name], field.reload.name
  end

  test "update a field with errors" do
    field = FactoryBot.create(:field)
    attributes = FactoryBot.attributes_for(:field, name: nil).except(:tournament)
    input = {field_id: field.id, **attributes}

    execute_graphql("updateField", "UpdateFieldInput", input, @output)
    assert_failure({'field' => 'name', 'message' => "can't be blank"})
  end
end
