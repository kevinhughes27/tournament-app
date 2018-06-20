require 'test_helper'

class DeleteFieldTest < ApiTest
  setup do
    login_user
    @output = '{ success, confirm, userErrors }'
  end

  test "delete a field" do
    field = FactoryBot.create(:field)
    input = {field_id: field.id}

    assert_difference "Field.count", -1 do
      execute_graphql("deleteField", "DeleteFieldInput", input, @output)
      assert_success
    end
  end

  test "delete a field needs confirm" do
    field = FactoryBot.create(:field)
    FactoryBot.create(:game, :scheduled, field: field)
    input = {field_id: field.id}

    assert_no_difference "Field.count" do
      execute_graphql("deleteField", "DeleteFieldInput", input, @output)
      assert_confirmation_required "There are games scheduled on this field. Deleting will leave these games unassigned. You can re-assign them on the schedule page however if your Tournament is in progress this is probably not something you want to do."
    end
  end

  test "confirm delete a field" do
    field = FactoryBot.create(:field)
    FactoryBot.create(:game, :scheduled, field: field)
    input = {field_id: field.id, confirm: true}

    assert_difference "Field.count", -1 do
      execute_graphql("deleteField", "DeleteFieldInput", input, @output)
      assert_success
    end
  end

  test "deleting a field unschedules any games from that field" do
    field = FactoryBot.create(:field)
    game = FactoryBot.create(:game, :scheduled, field: field)
    input = {field_id: field.id, confirm: true}

    execute_graphql("deleteField", "DeleteFieldInput", input, @output)

    assert_nil game.reload.field
    assert_nil game.start_time
  end
end
