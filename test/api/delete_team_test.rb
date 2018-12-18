require 'test_helper'

class DeleteTeamTest < ApiTest
  setup do
    login_user
    @output = '{ success message userErrors { field message } }'
  end

  test "delete a team" do
    team = FactoryBot.create(:team)
    input = {id: team.id}

    assert_difference "Team.count", -1 do
      execute_graphql("deleteTeam", "DeleteTeamInput", input, @output)
      assert_success
    end
  end

  test "delete a team not allowed if assigned to any games" do
    division = FactoryBot.create(:division)
    team = FactoryBot.create(:team, division: division)
    FactoryBot.create(:seed, division: division, team: team)
    FactoryBot.create(:game, division: division, home: team)

    input = {id: team.id}

    assert_no_difference "Team.count" do
      execute_graphql("deleteTeam", "DeleteTeamInput", input, @output)
      assert_failure "There are games scheduled for this team. In order to delete this team you need to delete the #{team.division.name} division first."
    end
  end
end
