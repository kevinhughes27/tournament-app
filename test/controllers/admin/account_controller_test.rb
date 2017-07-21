require 'test_helper'

class Admin::AccountControllerTest < AdminControllerTestCase
  test "get account page" do
    get :show
    assert_response :success
  end

  test "update account" do
    put :update, params: { user: { email: 'bob@example.com' } }
    assert_response :success
    assert_equal 'bob@example.com', @user.reload.email
    assert_equal 'Account updated.', flash[:notice]
  end

  test "update account error" do
    put :update, params: { user: { email: '' } }
    assert_response :success
    assert @user.reload.email.present?
  end
end
