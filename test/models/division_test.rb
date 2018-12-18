require 'test_helper'

class DivisionTest < ActiveSupport::TestCase
  test "division deletes games when it is deleted" do
    division = FactoryBot.create(:division)
    FactoryBot.create(:game, division: division)

    assert_difference "Game.count", -1 do
      division.destroy
    end
  end

  test "division deletes places when it is deleted" do
    division = FactoryBot.create(:division)
    FactoryBot.create(:place, division: division)

    assert_difference "Place.count", -1 do
      division.destroy
    end
  end

  test "division nullifies teams when it is deleted" do
    division = FactoryBot.create(:division)
    team = FactoryBot.create(:team, division: division)

    division.destroy

    assert team.reload.division.nil?
  end

  test "dirty_seed? calls operation" do
    division = FactoryBot.build(:division)
    DirtySeedCheck.expects(:perform)
    division.dirty_seed?
  end

  test "limited number of divisions per tournament" do
    tournament = FactoryBot.create(:tournament)
    FactoryBot.create(:division, tournament: tournament)

    stub_constant(Division, :LIMIT, 1) do
      division = tournament.divisions.build
      refute division.valid?
      assert_equal ['Maximum of 1 divisions exceeded'], division.errors[:base]
    end
  end

  test "limit is defined" do
    assert_equal 12, Division::LIMIT
  end
end
