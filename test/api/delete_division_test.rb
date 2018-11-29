require 'test_helper'

class DeleteDivisionTest < ApiTest
  setup do
    login_user
    @output = '{ success confirm message userErrors { field message } }'
  end

  test "delete a division" do
    division = FactoryBot.create(:division)
    input = {id: relay_id('Division', division.id)}

    assert_difference "Division.count", -1 do
      execute_graphql("deleteDivision", "DeleteDivisionInput", input, @output)
      assert_success
    end
  end

  test "unsafe delete a division needs confirm" do
    division = FactoryBot.create(:division)
    game = FactoryBot.create(:game, :finished, division: division)
    input = {id: relay_id('Division', division.id)}

    assert_no_difference "Division.count" do
      execute_graphql("deleteDivision", "DeleteDivisionInput", input, @output)
      assert_confirmation_required "This division has games that have been scored. Deleting this division will delete all the games that belong to it. Are you sure this is what you want to do?"
    end
  end

  test "confirm delete a division" do
    division = FactoryBot.create(:division)
    game = FactoryBot.create(:game, :finished, division: division)
    input = {id: relay_id('Division', division.id), confirm: true}

    assert_difference "Division.count", -1 do
      execute_graphql("deleteDivision", "DeleteDivisionInput", input, @output)
      assert_success
    end
  end

  test "deleting a division deletes games" do
    division = FactoryBot.create(:division)
    game = FactoryBot.create(:game, :scheduled, division: division)
    input = {id: relay_id('Division', division.id)}

    assert_difference "Division.count", -1 do
      execute_graphql("deleteDivision", "DeleteDivisionInput", input, @output)
      assert_success
    end

    assert_nil Game.find_by(id: game.id)
  end
end
