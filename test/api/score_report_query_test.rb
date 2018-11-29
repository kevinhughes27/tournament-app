require 'test_helper'

class ScoreReportQueryTest < ApiTest
  test "scoreReports are hidden to public" do
    report = FactoryBot.create(:score_report)

    query_graphql(
      "scoreReports {
      	homeScore
        awayScore
      }",
      expect_error: "Field 'scoreReports' doesn't exist on type 'Query'"
    )
  end

  test "scoreReports" do
    login_user
    report = FactoryBot.create(:score_report)

    query_graphql("
      scoreReports {
      	homeScore
        awayScore
      }
    ")

    assert_equal report.home_score, query_result['scoreReports'].first['homeScore']
  end

  test "scoreReport are hidden to public" do
    report = FactoryBot.create(:score_report)
    report_id = relay_id('ScoreReport', report.id)

    query_graphql(
      "scoreReport(id: #{report_id}) {
      	homeScore
        awayScore
      }",
      expect_error: "Field 'scoreReport' doesn't exist on type 'Query'"
    )
  end

  test "scoreReport" do
    login_user
    report = FactoryBot.create(:score_report)
    report_id = relay_id('ScoreReport', report.id)

    query_graphql("
      scoreReport(id: #{report_id}) {
      	homeScore
        awayScore
      }
    ")

    assert_equal report.home_score, query_result['scoreReport']['homeScore']
  end
end
