require 'test_helper'

class AdvanceBracketJobTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @tournament = tournaments(:noborders)
    @division = divisions(:open)
    @home = teams(:swift)
    @away = teams(:goose)
  end

  test "pushes winner through the bracket" do
    game1 = Game.create!(
      tournament: @tournament,
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

    game2 = Game.create!(
      tournament: @tournament,
      division: @division,
      round: 2,
      bracket_uid: 's1',
      home_prereq: 'Wq1',
      away_prereq: 'Wq2'
    )

    AdvanceBracket.perform(game1)
    assert_equal @home, game2.reload.home
  end

  test "pushes loser through the bracket" do
    game1 = Game.create!(
      tournament: @tournament,
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

    game2 = Game.create!(
      tournament: @tournament,
      division: @division,
      round: 2,
      bracket_uid: 'c1',
      home_prereq: 'Lq2',
      away_prereq: 'Lq1'
    )

    AdvanceBracket.perform(game1)
    assert_equal @away, game2.reload.away
  end

  test "resets dependent_games if required" do
    game1 = Game.create!(
      tournament: @tournament,
      division: @division,
      round: 1,
      bracket_uid: 'q1',
      home_prereq: '1',
      away_prereq: '2',
      home: @home,
      away: @away,
      home_score: 11,
      away_score: 15
    )

    game2 = Game.create!(
      tournament: @tournament,
      division: @division,
      round: 2,
      bracket_uid: 's1',
      home_prereq: 'Wq1',
      away_prereq: 'Wq2',
      home: @home,
      home_score: 11,
      away_score: 15
    )

    perform_enqueued_jobs do
      AdvanceBracket.perform(game1)
      assert_equal @away, game2.reload.home
      refute game2.confirmed?
    end
  end

  test "resets future games as required (recursive reset)" do
    game1 = Game.create!(
      tournament: @tournament,
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

    game2 = Game.create!(
      tournament: @tournament,
      division: @division,
      round: 2,
      bracket_uid: 's1',
      home_prereq: 'Wq1',
      away_prereq: 'Wq2',
      home: @home,
      home_score: 15,
      away_score: 11
    )

    game3 = Game.create!(
      tournament: @tournament,
      division: @division,
      round: 3,
      bracket_uid: 'f1',
      home_prereq: 'Ws1',
      away_prereq: 'Ws2',
      home: @home,
      home_score: 15,
      away_score: 11
    )

    perform_enqueued_jobs do
      AdvanceBracket.perform(game1)
      refute game2.reload.confirmed?
      assert_nil game3.reload.home
    end
  end
end
