require 'test_helper'

class AdvanceBracketTest < OperationTest
  include ActiveJob::TestHelper

  test "pushes winner through the bracket" do
    game1 = FactoryGirl.create(:game,
      round: 1,
      bracket_uid: 'q1',
      home_score: 15,
      away_score: 11
    )

    game2 = FactoryGirl.create(:game,
      round: 2,
      home_prereq: 'Wq1',
    )

    AdvanceBracket.perform(game1)
    assert_equal game1.home, game2.reload.home
  end

  test "pushes loser through the bracket" do
    game1 = FactoryGirl.create(:game,
      round: 1,
      bracket_uid: 'q1',
      home_score: 15,
      away_score: 11
    )

    game2 = FactoryGirl.create(:game,
      round: 2,
      away_prereq: 'Lq1'
    )

    AdvanceBracket.perform(game1)
    assert_equal game1.away, game2.reload.away
  end

  test "resets dependent_games if required" do
    team = FactoryGirl.create(:team)

    game1 = FactoryGirl.create(:game,
      round: 1,
      bracket_uid: 'q1',
      home: team,
      home_score: 11,
      away_score: 15
    )

    game2 = FactoryGirl.create(:game,
      round: 2,
      home_prereq: 'Wq1',
      home: team,
      home_score: 11,
      away_score: 15
    )

    perform_enqueued_jobs do
      AdvanceBracket.perform(game1)
      assert_equal game1.away, game2.reload.home
      refute game2.confirmed?
    end
  end

  test "resets future games as required (recursive reset)" do
    team = FactoryGirl.create(:team)

    game1 = FactoryGirl.create(:game,
      round: 1,
      bracket_uid: 'q1',
      home: team,
      home_score: 15,
      away_score: 11
    )

    game2 = FactoryGirl.create(:game,
      round: 2,
      bracket_uid: 's1',
      home_prereq: 'Wq1',
      home: team,
      home_score: 15,
      away_score: 11
    )

    game3 = FactoryGirl.create(:game,
      round: 3,
      home_prereq: 'Ws1',
      home: team,
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
