require 'test_helper'

class DivisionTest < ActiveSupport::TestCase
  test "division deletes games when it is deleted" do
    division = FactoryGirl.create(:division)
    FactoryGirl.create(:game, division: division)

    assert_difference "Game.count", -1 do
      division.destroy
    end
  end

  test "division deletes places when it is deleted" do
    division = FactoryGirl.create(:division)
    FactoryGirl.create(:place, division: division)

    assert_difference "Place.count", -1 do
      division.destroy
    end
  end

  test "division nullifies teams when it is deleted" do
    division = FactoryGirl.create(:division)
    team = FactoryGirl.create(:team, division: division)

    division.destroy

    assert team.reload.division.nil?
  end

  test "dirty_seed? calls operation" do
    division = FactoryGirl.build(:division)
    DirtySeedCheck.expects(:perform)
    division.dirty_seed?
  end

  test "safe_to_delete? is true for division with no games played" do
    division = FactoryGirl.create(:division)
    FactoryGirl.create(:game, division: division)

    assert division.safe_to_delete?
  end

  test "safe_to_delete? is false for division with games played" do
    division = FactoryGirl.create(:division)
    FactoryGirl.create(:game, :finished, division: division)

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

  test "limit is defined" do
    assert_equal 12, Division::LIMIT
  end

  test "bracket_games scope" do
    division = FactoryGirl.create(:division)
    game = FactoryGirl.create(:game, division: division)

    bracket_games = division.bracket_games
    assert bracket_games.first.bracket_uid
  end

  test "pool_games scope" do
    division = FactoryGirl.create(:division)
    game = FactoryGirl.create(:pool_game, division: division)

    pool_games = division.pool_games('A')
    assert_equal 'A', pool_games.first.pool
  end
end
