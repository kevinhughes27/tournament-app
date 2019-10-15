require 'test_helper'

class SettingsBrowserTest < AdminTest
  test 'update settings' do
    visit_app
    login
    side_menu('Settings')
    edit_settings
    logout
  end

  private

  def edit_settings
    assert_text 'Score Confirmation Setting'

    fill_in('name', with: ' ')
    fill_in('name', with: 'No Borders')
    fill_in('scoreSubmitPin', with: '1111')

    submit
    assert_text('Settings updated')

    @tournament.reload
    assert_equal 'No Borders', @tournament.name
    assert_equal '1111', @tournament.score_submit_pin
  end
end
