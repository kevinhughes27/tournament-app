require 'test_helper'

class SettingBrowserTest < BrowserTest
  test 'settings' do
    visit("http://www.#{Settings.host}/settings")
    fill_in('email', with: Faker::Internet.email)
    find('button[type="submit"]').click
    click_button 

    # for animation
    sleep(1)

    assert_text 'User updated'
  end
end
