require "test_helper"

class DeepLinkTest < PlayerAppTest
  test 'deep link' do
    report = FactoryBot.create(:score_report,
      game: @game,
      team: @team,
      home_score: 10,
      away_score: 8
    )

    deep_link = report.build_confirm_link

    visit(deep_link)
    enter_comment('Yup thats the score')

    # submitted by home team
    # deep link is confirming a loss
    submit_loss

    assert_submitted
    assert_confirmed_report(report, comment: 'Yup thats the score')
    # does deep link submit clear the url?
  end

  # test deep link overrides previously submitted score by the user
end
