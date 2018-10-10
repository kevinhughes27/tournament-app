require 'test_helper'

class UserProfileBrowserTest < AdminNextTestCase
  test 'change password' do
    visit_app
    login
    user_menu('Profile')
    change_password
    logout
  end

  private

  def change_password
    assert_text 'Confirm Password'

    fill_in('password', with: 'password')
    fill_in('passwordConfirmation', with: 'password')

    submit
    assert_text('Password changed')
  end
end
