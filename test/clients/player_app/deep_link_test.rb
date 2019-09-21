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

    # deep link is cleared after submit
    assert_equal 'http://no-borders.lvh.me:3000/submit', current_url
  end

  test 'deep link overrides previously submitted score by the user' do
    visit_app
    search_for_team('Swift')
    navigate_to_submit
    click_on_game(@game)
    enter_score(15, 11)
    submit_win

    assert_submitted
    assert_report('Swift', @game, 15, 11)

    # other team's report
    report = FactoryBot.create(:score_report,
      game: @game,
      team: @opponent,
      home_score: 15,
      away_score: 12
    )

    deep_link = report.build_confirm_link

    visit(deep_link)
    enter_comment('Oops they did have 12')

    submit_win
    assert_submitted
    assert_report('Swift', @game, 15, 12)
    assert_confirmed_report(report, comment: 'Oops they did have 12')
  end
end
