require 'test_helper'

class UpdateDivisionTest < ApiTest
  setup do
    login_user
    @output = '{ success, confirm, userErrors }'
  end

  test "update a division" do
    division = FactoryGirl.create(:division)
    input = {division_id: division.id, name: 'Junior Open', bracket_type: 'single_elimination_8'}

    execute_graphql("updateDivision", "UpdateDivisionInput", input, @output)

    assert_success
    assert_equal input[:name], division.reload.name
  end

  test "update a division (unsafe scheduled)" do
    division = FactoryGirl.create(:division)
    game = FactoryGirl.create(:game, :scheduled, division: division)
    input = {division_id: division.id, bracket_type: 'single_elimination_4'}

    execute_graphql("updateDivision", "UpdateDivisionInput", input, @output)
    assert_confirmation_required "This division has games that have been scheduled. Changing the bracket might reset some of those games. Are you sure this is what you want to do?"
  end

  test "update a division (unsafe scored)" do
    division = FactoryGirl.create(:division)
    game = FactoryGirl.create(:game, :finished, division: division)
    input = {division_id: division.id, bracket_type: 'single_elimination_4'}

    execute_graphql("updateDivision", "UpdateDivisionInput", input, @output)
    assert_confirmation_required "This division has games that have been scored. Changing the bracket will reset those games. Are you sure this is what you want to do?"
  end

  test "update a division (unsafe) + confirm" do
    division = FactoryGirl.create(:division)
    input = {division_id: division.id, bracket_type: 'single_elimination_4', confirm: true}

    execute_graphql("updateDivision", "UpdateDivisionInput", input, @output)

    assert_success
    assert_equal input[:bracket_type], division.reload.bracket_type
  end

  test "update a division with errors" do
    division = FactoryGirl.create(:division)
    input = {division_id: division.id, name: ''}

    execute_graphql("updateDivision", "UpdateDivisionInput", input, @output)
    assert_failure "Name can't be blank"
  end

  test "updating the bracket_type clears the previous games" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(params)
    assert_equal 12, division.games.count

    input = {division_id: division.id, bracket_type: 'single_elimination_4'}
    execute_graphql("updateDivision", "UpdateDivisionInput", input, @output)

    assert_success
    assert_equal 4, division.games.count
  end

  test "updating the bracket_type resets seeded status" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(params)

    teams = (1..8).map do |seed|
      FactoryGirl.create(:team, division: division, seed: seed)
    end

    seed_division(division)
    assert division.reload.seeded?

    input = {division_id: division.id, bracket_type: 'single_elimination_4'}
    execute_graphql("updateDivision", "UpdateDivisionInput", input, @output)

    assert_success
    refute division.reload.seeded?
  end

  test "updating the bracket_type clears the previous places" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(params)
    assert_equal 8, division.places.count

    input = {division_id: division.id, bracket_type: 'single_elimination_4'}
    execute_graphql("updateDivision", "UpdateDivisionInput", input, @output)

    assert_success
    assert_equal 4, division.places.count
  end

  private

  def create_division(params)
    input = params.except(:tournament)
    execute_graphql("createDivision", "CreateDivisionInput", input)
    assert_success
    Division.last
  end

  def seed_division(division)
    execute_graphql("seedDivision", "SeedDivisionInput", {division_id: division.id})
    assert_success
  end
end