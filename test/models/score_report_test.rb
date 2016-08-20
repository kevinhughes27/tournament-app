require 'test_helper'

class ScoreReportTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @game = games(:pheonix_mavericks)
  end

  test "home/away scores are correct if submitted by home team" do
    report = score_reports(:swift_goose)
    assert_equal 15, report.home_score
    assert_equal 11, report.away_score
  end

  test "home/away scores are correct if submitted by away team" do
    report = score_reports(:swift_goose_by_goose)
    assert_equal 15, report.home_score
    assert_equal 11, report.away_score
  end

  test "submitter_won? returns true if the submitter won the game" do
    assert score_reports(:swift_goose).submitter_won?
    refute score_reports(:swift_goose_by_goose).submitter_won?
  end

  test "other_team" do
    assert_equal teams(:goose), score_reports(:swift_goose).other_team
    assert_equal teams(:swift), score_reports(:swift_goose_by_goose).other_team
  end

  test "is soft deleted" do
    report = score_reports(:swift_goose_by_goose)
    report.destroy()
    assert report.deleted?
  end

  test "soft deleted objects not in query" do
    report = score_reports(:swift_goose_by_goose)
    report.destroy()
    assert_equal 1, @tournament.score_reports.all.size
  end
end
