require 'test_helper'

class Admin::TestCaseController < AdminController
  def index
    render_index
  end

  def render_index
    render plain: "OK"
  end
end

Rails.application.routes.disable_clear_and_finalize = true

Rails.application.routes.draw do
  get 'admin/testcase' => 'admin/test_case#index'
end

class Admin::TestCaseControllerTest < ActionController::TestCase

  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    @user = users(:kevin)
  end

  test "admin requires login" do
    sign_in @user
    get :index
    assert_response :success
  end

  test "admin redirects to login if no session" do
    sign_out @user
    get :index
    assert_redirected_to new_user_session_path
  end

  test "non existent tournament 404s" do
    set_tournament('wat')
    get :index
    assert_response :not_found
    assert_template 'login/404', layout: 'login'
  end

  # test "404 error (html)" do
  #   sign_in @user
  #   @controller.expects(:render_index).raises(ActiveRecord::RecordNotFound)
  #   get :index
  #   assert_response :not_found
  #   assert_template 'admin/404'
  # end

  test "500 error (html)" do
    sign_in @user
    @controller.expects(:render_index).raises
    get :index
    assert_response 500
    assert_template 'admin/500'
  end

  test "500 error (pdf)" do
    sign_in @user
    @controller.expects(:render_index).raises
    get :index, format: :pdf
    assert_response 500
  end
end
