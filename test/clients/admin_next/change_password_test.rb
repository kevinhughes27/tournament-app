require 'test_helper'

class UserProfileBrowserTest < AdminNextTestCase
  test 'change password' do
    visit_app
    login
    navigate_to_profile
    change_password
    logout
  end

  private

  def navigate_to_profile
    find('#user-menu').click
    click_on('Profile')
  end

  def change_password
    assert_text 'Confirm Password'

    fill_in('password', with: 'password')
    fill_in('passwordConfirmation', with: 'password')

    click_save
    assert_text('Password changed')
  end
end
