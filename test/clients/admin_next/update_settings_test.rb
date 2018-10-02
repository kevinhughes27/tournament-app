require 'test_helper'

class SettingsBrowserTest < AdminNextTestCase
  test 'update settings' do
    visit_app
    login
    navigate_to_settings
    edit_settings
    logout
  end

  private

  def navigate_to_settings
    find('#user-menu').click
    click_on('Settings')
  end

  def edit_settings
    assert_text 'Score Confirmation Setting'

    fill_in('name', with: ' ')
    fill_in('name', with: 'No Borders')
    fill_in('scoreSubmitPin', with: '1111')

    click_save
    assert_text('Settings updated')

    @tournament.reload
    assert_equal 'No Borders', @tournament.name
    assert_equal '1111', @tournament.score_submit_pin
  end
end
