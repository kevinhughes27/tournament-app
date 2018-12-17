require "test_helper"

class DeepLinkTest < PlayerAppTest
  test 'deep link' do
    report = FactoryBot.create(:score_report, game: @game, team: @team)

    deep_link = report.build_confirm_link

    visit(deep_link)
    enter_comment('Yup thats the score')
    submit_score

    assert_submitted
    assert_confirmed_report(report, comment: 'Yup thats the score')
  end
end
