require "test_helper"

class SubmitTest < PlayerAppTest
  test 'submit a score' do
    visit_app
    search_for_team('Swift')
    navigate_to_submit
    click_on_game(@game)
    enter_score(15, 11)
    submit_score

    assert_submitted
    assert_report('Swift', @game, 15, 11)
  end

  test 'submit a score (with pin)' do
    @tournament.update_column(:score_submit_pin, '1234')

    visit_app
    search_for_team('Swift')
    navigate_to_submit
    enter_pin('1234')
    click_on_game(@game)
    enter_score(15, 11)
    submit_score

    assert_submitted
    assert_report('Swift', @game, 15, 11)
  end

  test 'submit a score (lowercase search)' do
    visit_app
    search_for_team('swift')
    navigate_to_submit
    click_on_game(@game)
    enter_score(15, 11)
    submit_score

    assert_submitted
    assert_report('Swift', @game, 15, 11)
  end
end
