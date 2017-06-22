require 'test_helper'

class ScoreReportTest < ActiveSupport::TestCase
  test "home/away scores are correct if submitted by home team" do
    tournament = FactoryGirl.create(:tournament)
    game = FactoryGirl.create(:game, tournament: tournament)

    report = FactoryGirl.build(:score_report,
      tournament: tournament,
      game: game,
      team: game.home,
      team_score: 15,
      opponent_score: 11
    )

    assert_equal 15, report.home_score
    assert_equal 11, report.away_score
  end

  test "home/away scores are correct if submitted by away team" do
    tournament = FactoryGirl.create(:tournament)
    game = FactoryGirl.create(:game, tournament: tournament)

    report = FactoryGirl.build(:score_report,
      tournament: tournament,
      game: game,
      team: game.away,
      team_score: 11,
      opponent_score: 15
    )

    assert_equal 15, report.home_score
    assert_equal 11, report.away_score
  end

  test "submitter_won? returns true if the submitter won the game" do
    tournament = FactoryGirl.create(:tournament)
    game = FactoryGirl.create(:game, tournament: tournament)

    report = FactoryGirl.build(:score_report,
      tournament: tournament,
      game: game,
      team: game.home,
      team_score: 15,
      opponent_score: 11
    )

    assert report.submitter_won?
  end

  test "submitter_won? returns false if the submitter lost the game" do
    tournament = FactoryGirl.create(:tournament)
    game = FactoryGirl.create(:game, tournament: tournament)

    report = FactoryGirl.build(:score_report,
      tournament: tournament,
      game: game,
      team: game.home,
      team_score: 11,
      opponent_score: 15
    )

    refute report.submitter_won?
  end

  test "other_team" do
    tournament = FactoryGirl.create(:tournament)
    game = FactoryGirl.create(:game, tournament: tournament)

    report = FactoryGirl.build(:score_report,
      tournament: tournament,
      game: game,
      team: game.home,
      team_score: 15,
      opponent_score: 11
    )

    assert_equal game.away, report.other_team
  end

  test "is soft deleted" do
    tournament = FactoryGirl.create(:tournament)
    game = FactoryGirl.create(:game, tournament: tournament)
    report = FactoryGirl.create(:score_report, tournament: tournament, game: game)

    report.destroy()
    assert report.deleted?
  end

  test "soft deleted objects not in query" do
    tournament = FactoryGirl.create(:tournament)
    game = FactoryGirl.create(:game, tournament: tournament)
    report = FactoryGirl.create(:score_report, tournament: tournament, game: game)

    report.destroy()
    assert_equal 0, tournament.score_reports.all.size
  end
end
