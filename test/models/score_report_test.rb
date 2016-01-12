require 'test_helper'

class ScoreReportTest < ActiveSupport::TestCase

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

end
