require 'test_helper'

class UpdatePlacesTest < OperationTest
  setup do
    @division = FactoryGirl.create(:division)
    @home = FactoryGirl.create(:team, division: @division)
    @away = FactoryGirl.create(:team, division: @division)
  end

  test "pushes winner to a place" do
    game = FactoryGirl.create(:game,
      division: @division,
      round: 1,
      bracket_uid: 'q1',
      home_prereq: '1',
      away_prereq: '2',
      home: @home,
      away: @away,
      home_score: 15,
      away_score: 11
    )

    place = Place.create!(
      tournament: @tournament,
      division: @division,
      prereq: 'Wq1',
      position: 1
    )

    UpdatePlaces.perform(game)

    assert_equal @home, place.reload.team
  end

  test "pushes loser to a place" do
    game = FactoryGirl.create(:game,
      division: @division,
      round: 1,
      bracket_uid: 'q1',
      home_prereq: '1',
      away_prereq: '2',
      home: @home,
      away: @away,
      home_score: 15,
      away_score: 11
    )

    place = Place.create!(
      tournament: @tournament,
      division: @division,
      prereq: 'Lq1',
      position: 2
    )

    UpdatePlaces.perform(game)

    assert_equal @away, place.reload.team
  end
end
