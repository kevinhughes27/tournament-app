require 'test_helper'

class ScoreReportTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @report = score_reports(:swift_goose_by_goose)
  end

  test "home/away scores are correct if submitted by home team" do
    report = score_reports(:swift_goose)
    assert_equal 15, report.home_score
    assert_equal 11, report.away_score
  end

  test "home/away scores are correct if submitted by away team" do
    assert_equal 15, @report.home_score
    assert_equal 11, @report.away_score
  end

  test "is soft deleted" do
    @report.destroy()
    assert @report.deleted?
  end

  test "soft deleted objects not in query" do
    @report.destroy()
    assert_equal 1, @tournament.score_reports.all.size
  end
end
