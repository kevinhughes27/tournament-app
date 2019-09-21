require "test_helper"

class SubmitTest < PlayerAppTest
  test 'submit a score (win)' do
    visit_app
    search_for_team('Swift')
    navigate_to_submit
    click_on_game(@game)
    enter_score(15, 11)
    submit_win

    assert_submitted
    assert_report('Swift', @game, 15, 11)
  end

  test 'submit a score (loss)' do
    visit_app
    search_for_team('Swift')
    navigate_to_submit
    click_on_game(@game)
    enter_score(10, 12)
    submit_loss

    assert_submitted
    assert_report('Swift', @game, 10, 12)
  end

  test 'submit a score (with pin)' do
    @tournament.update_column(:score_submit_pin, '1234')

    visit_app
    search_for_team('Swift')
    navigate_to_submit
    enter_pin('1234')
    click_on_game(@game)
    enter_score(15, 11)
    submit_win

    assert_submitted
    assert_report('Swift', @game, 15, 11)
  end

  test 'submit a score (lowercase search)' do
    visit_app
    search_for_team('swift')
    navigate_to_submit
    click_on_game(@game)
    enter_score(15, 11)
    submit_win

    assert_submitted
    assert_report('Swift', @game, 15, 11)
  end

  test 're-submit a score (edit)' do
    # only creates one entry in the db
  end
end
