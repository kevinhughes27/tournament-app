require 'test_helper'

class CreateDivisionTest < ApiTest
  setup do
    login_user
    @output = '{ success, errors }'
  end

  test "division creates all required games" do
    type = 'single_elimination_4'
    input = FactoryGirl.attributes_for(:division, bracket_type: type).except(:tournament)

    assert_difference "Game.count", +4 do
      execute_graphql("createDivision", "CreateDivisionInput", input, @output)
      assert_success
    end
  end

  test "division creates all required places" do
    type = 'single_elimination_4'
    input = FactoryGirl.attributes_for(:division, bracket_type: type).except(:tournament)

    assert_difference "Place.count", +4 do
      execute_graphql("createDivision", "CreateDivisionInput", input, @output)
      assert_success
    end
  end

  test "creates games as spec'd by the bracket template" do
    type = 'single_elimination_8'
    input = FactoryGirl.attributes_for(:division, bracket_type: type).except(:tournament)

    execute_graphql("createDivision", "CreateDivisionInput", input, @output)
    assert_success

    template = Bracket.find_by(handle: type).template
    template_game = template[:games].first
    game = Game.find_by(bracket_uid: template_game[:bracket_uid])

    assert game
    assert_equal template_game[:home_prereq].to_s, game.home_prereq
    assert_equal template_game[:away_prereq].to_s, game.away_prereq
  end

  test "creates places as spec'd by the bracket template" do
    type = 'single_elimination_8'
    input = FactoryGirl.attributes_for(:division, bracket_type: type).except(:tournament)

    execute_graphql("createDivision", "CreateDivisionInput", input, @output)
    assert_success

    template = Bracket.find_by(handle: type).template
    template_place = template[:places].first

    assert Place.find_by(prereq: template_place[:prereq])
  end
end
