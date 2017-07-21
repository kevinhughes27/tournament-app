require 'test_helper'

class DivisionTest < ActiveSupport::TestCase
  test "division deletes games when it is deleted" do
    tournament = FactoryGirl.create(:tournament)
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_4')
    division = DivisionCreate.perform(tournament, params)

    assert_difference "Game.count", -4 do
      division.destroy
    end
  end

  test "division deletes places when it is deleted" do
    tournament = FactoryGirl.create(:tournament)
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_4')
    division = DivisionCreate.perform(tournament, params)

    assert_difference "Place.count", -4 do
      division.destroy
    end
  end

  test "division nullifies teams when it is deleted" do
    division = FactoryGirl.create(:division)
    team = FactoryGirl.create(:team, division: division)

    teams = division.teams
    assert teams.present?

    division.destroy

    assert teams.reload.all? { |team| team.division.nil? }
  end

  test "dirty_seed? calls operation" do
    division = FactoryGirl.build(:division)
    DirtySeedCheck.expects(:perform)
    division.dirty_seed?
  end

  test "safe_to_delete? is true for division with no games played" do
    tournament = FactoryGirl.create(:tournament)
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_4')
    division = DivisionCreate.perform(tournament, params)

    assert division.safe_to_delete?
  end

  test "safe_to_delete? is false for division with games played" do
    tournament = FactoryGirl.create(:tournament)
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_4')
    division = DivisionCreate.perform(tournament, params)
    division.games.first.update_columns(score_confirmed: true)

    refute division.safe_to_delete?
  end

  test "limited number of divisions per tournament" do
    tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:division, tournament: tournament)

    stub_constant(Division, :LIMIT, 1) do
      division = tournament.divisions.build
      refute division.valid?
      assert_equal ['Maximum of 1 divisions exceeded'], division.errors[:base]
    end
  end

  test "limit is define" do
    assert_equal 12, Division::LIMIT
  end

  test "bracket_games scope" do
    tournament = FactoryGirl.create(:tournament)
    params = FactoryGirl.attributes_for(:division, bracket_type: 'USAU 4.2.1')
    division = DivisionCreate.perform(tournament, params)

    bracket_games = division.bracket_games
    assert bracket_games.first.bracket_uid
  end

  test "pool_games scope" do
    tournament = FactoryGirl.create(:tournament)
    params = FactoryGirl.attributes_for(:division, bracket_type: 'USAU 4.2.1')
    division = DivisionCreate.perform(tournament, params)

    pool_games = division.pool_games('A')
    assert_equal 'A', pool_games.first.pool
  end
end
