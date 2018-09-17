require 'test_helper'

class SettingBrowserTest < BrowserTest
  setup do
    @tournament = FactoryBot.create(:tournament, handle: 'no-borders')
  end
  test 'settings' do
    visit("http://#{@tournament.handle}.#{Settings.host}/user")
    fill_in('user_password', with: "12345678")
    find('button[type="submit"]').click
    click_button 
    assert_text 'User updated'
  end
end
