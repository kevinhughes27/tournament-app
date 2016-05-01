require 'test_helper'

class FakeInternalController < InternalController
  def index
    render plain: "OK"
  end
end

Rails.application.routes.disable_clear_and_finalize = true

Rails.application.routes.draw do
  controller :fake_internal do
    get 'index' => :index
  end
end

class InternalControllerTest < ActionController::TestCase
  tests FakeInternalController

  setup do
    set_subdomain('www')
  end

  test "admin requires staff login" do
    sign_out users(:kevin)
    get :index
    assert_redirected_to new_internal_user_session_path
  end

  test "admin with staff login" do
    sign_in :internal_user, users(:kevin)
    get :index
    assert_response :success
  end

  test "admin 404s for non staff login" do
    sign_in :internal_user, users(:bob)
    get :index
    assert_redirected_to new_internal_user_session_path
  end
end
