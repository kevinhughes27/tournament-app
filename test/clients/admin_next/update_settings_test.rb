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
    assert_text @tournament.name

    fill_in('name', with: 'no-borders')
    fill_in('handle', with: 'no-borders')
    fill_in('scoreSubmitPin', with: '1111')

    click_save
    assert_text('Settings updated')
  end
end
