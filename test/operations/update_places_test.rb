require 'test_helper'

class UpdatePlacesTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @division = divisions(:open)
    @home = teams(:swift)
    @away = teams(:goose)
  end

  test "pushes winner to a place" do
    game = Game.create!(
      tournament: @tournament,
      division: @division,
      round: 1,
      bracket_uid: 'q1',
      home_prereq: '1',
      away_prereq: '2',
      home: @home,
      away: @away
    )

    place = Place.create!(
      tournament: @tournament,
      division: @division,
      prereq: 'Wq1',
      position: 1
    )

    game.update_columns(home_score: 15, away_score: 11)
    UpdatePlaces.perform(game)

    assert_equal @home, place.reload.team
  end

  test "pushes loser to a place" do
    game = Game.create!(
      tournament: @tournament,
      division: @division,
      round: 1,
      bracket_uid: 'q1',
      home_prereq: '1',
      away_prereq: '2',
      home: @home,
      away: @away
    )

    place = Place.create!(
      tournament: @tournament,
      division: @division,
      prereq: 'Lq1',
      position: 2
    )

    game.update_columns(home_score: 15, away_score: 11)
    UpdatePlaces.perform(game)

    assert_equal @away, place.reload.team
  end
end
