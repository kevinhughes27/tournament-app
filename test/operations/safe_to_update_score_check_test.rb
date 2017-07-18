require 'test_helper'

class SafeToUpdateScoreCheckTest < ActiveJob::TestCase
  test "safe if pool is not finished" do
    game1 = FactoryGirl.create(:pool_game, pool: 'A')
    game2 = FactoryGirl.create(:game, home_prereq: 'A1')

    assert SafeToUpdateScoreCheck.perform(
      game: game1,
      home_score: 2,
      away_score: 1
    ), 'expected update to be safe'
  end

  test "safe if pool results change but bracket hasn't started" do
    game1 = FactoryGirl.create(:pool_game, :finished, pool: 'A')
    game2 = FactoryGirl.create(:game, home_prereq: 'A1')

    assert SafeToUpdateScoreCheck.perform(
      game: game1,
      home_score: game1.away_score,
      away_score: game1.home_score
    ), 'expected update to be safe'
  end

  test "safe if pool is finished but results are not changed zzz" do
    game1 = FactoryGirl.create(:pool_game, :finished, pool: 'A')
    game2 = FactoryGirl.create(:game, :finished, home_prereq: 'A1')
    FactoryGirl.create(:pool_result, team: game1.home, position: 1)
    FactoryGirl.create(:pool_result, team: game1.away, position: 2)

    assert SafeToUpdateScoreCheck.perform(
      game: game1,
      home_score: game1.home_score + 1,
      away_score: game1.away_score + 1
    ), 'expected update to be safe'
  end

  test "unsafe if pool is finished and results change" do
    game1 = FactoryGirl.create(:pool_game, :finished, pool: 'A')
    game2 = FactoryGirl.create(:game, :finished, home_prereq: 'A1')
    FactoryGirl.create(:pool_result, team: game1.home, position: 1)
    FactoryGirl.create(:pool_result, team: game1.away, position: 2)

    refute SafeToUpdateScoreCheck.perform(
      game: game1,
      home_score: 1,
      away_score: 2
    ), 'expected update to be unsafe'
  end

  test "unsafe if dependent games are scored" do
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

    assert SafeToUpdateScoreCheck.perform(
      game: game1,
      home_score: game1.away_score,
      away_score: game1.home_score
    ), 'expected update to be safe'

    game2.update_column(:score_confirmed, true)

    refute SafeToUpdateScoreCheck.perform(
      game: game1,
      home_score: game1.away_score,
      away_score: game1.home_score
    ), 'expected update to be unsafe'
  end

  test "safe if winner doesn't change but dependent games are scored" do
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

    assert SafeToUpdateScoreCheck.perform(
      game: game1,
      home_score: game1.home_score,
      away_score: game1.away_score
    ), 'expected update to be safe'

    game2.update_column(:score_confirmed, true)

    assert SafeToUpdateScoreCheck.perform(
      game: game1,
      home_score: game1.home_score,
      away_score: game1.away_score
    ), 'expected update to be safe'
  end
end
