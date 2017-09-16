require 'test_helper'

class ScoreReportTest < ActiveSupport::TestCase
  test "submitter_won? returns true if the submitter won the game" do
    game = FactoryGirl.create(:game)

    report = FactoryGirl.build(:score_report,
      game: game,
      team: game.home,
      team_score: 15,
      opponent_score: 11
    )

    assert report.submitter_won?
  end

  test "submitter_won? returns false if the submitter lost the game" do
    game = FactoryGirl.create(:game)

    report = FactoryGirl.build(:score_report,
      game: game,
      team: game.home,
      team_score: 11,
      opponent_score: 15
    )

    refute report.submitter_won?
  end

  test "other_team" do
    game = FactoryGirl.create(:game)

    report = FactoryGirl.build(:score_report,
      game: game,
      team: game.home,
      team_score: 15,
      opponent_score: 11
    )

    assert_equal game.away, report.other_team
  end

  test "is soft deleted" do
    game = FactoryGirl.create(:game)
    report = FactoryGirl.create(:score_report, game: game)

    report.destroy()
    assert report.deleted?
  end

  test "soft deleted objects not in query" do
    game = FactoryGirl.create(:game)
    report = FactoryGirl.create(:score_report, game: game)

    report.destroy()
    assert_equal 0, ScoreReport.count
  end
end
