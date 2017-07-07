require 'test_helper'

class Internal::TestCaseController < InternalController
  def index
    render plain: "OK"
  end
end

Rails.application.routes.disable_clear_and_finalize = true

Rails.application.routes.draw do
  get 'internal/test_case' => 'internal/test_case#index'
end

class Internal::TestCaseControllerTest < ActionController::TestCase

  setup do
    set_subdomain('www')
  end

  test "admin requires staff login" do
    user = FactoryGirl.create(:staff)
    sign_out user
    get :index
    assert_redirected_to new_internal_user_session_path
  end

  test "admin with staff login" do
    user = FactoryGirl.create(:staff)
    sign_in user, scope: :internal_user
    get :index
    assert_response :success
  end

  test "admin 404s for non staff login" do
    user = FactoryGirl.create(:user)
    sign_in user, scope: :internal_user
    get :index
    assert_redirected_to new_internal_user_session_path
  end
end
