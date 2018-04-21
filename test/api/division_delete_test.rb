require 'test_helper'

class DivisionDeleteTest < ApiTest
  setup do
    login_user
  end

  test "delete a division" do
    division = FactoryGirl.create(:division)
    input = {division_id: division.id}

    assert_difference "Division.count", -1 do
      execute_graphql("divisionDelete", "DivisionDeleteInput", input)
      assert_success
    end
  end

  test "unsafe delete a division needs confirm" do
    division = FactoryGirl.create(:division)
    game = FactoryGirl.create(:game, :finished, division: division)
    input = {division_id: division.id}

    assert_no_difference "Division.count" do
      execute_graphql("divisionDelete", "DivisionDeleteInput", input)
      assert_confirmation_required "This division has games that have been scored. Deleting this division will delete all the games that belong to it. Are you sure this is what you want to do?"
    end
  end

  test "confirm delete a division" do
    division = FactoryGirl.create(:division)
    game = FactoryGirl.create(:game, :finished, division: division)
    input = {division_id: division.id, confirm: true}

    assert_difference "Division.count", -1 do
      execute_graphql("divisionDelete", "DivisionDeleteInput", input)
      assert_success
    end
  end

  test "deleting a division deletes games" do
    division = FactoryGirl.create(:division)
    game = FactoryGirl.create(:game, :scheduled, division: division)
    input = {division_id: division.id}

    assert_difference "Division.count", -1 do
      execute_graphql("divisionDelete", "DivisionDeleteInput", input)
      assert_success
    end

    assert_nil Game.find_by(id: game.id)
  end
end
