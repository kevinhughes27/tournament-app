require 'test_helper'

class LoginControllerTest < ActionController::TestCase

  setup do
    @user = users(:kevin)
    @tournament = tournaments(:noborders)
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "login page for tournament is shown if session has tournament_id" do
    set_session(@tournament)
    get :new
    assert_match /#{@tournament.handle}/, response.body
  end

  test "login page has field for tournament if session doesn't have tournament_id" do
    clear_session
    get :new
    assert_match /<input type=\"text\" name=\"tournament/, response.body
  end

  test "new clears session if redirected from brochure" do
    set_session(@tournament)
    request.env['HTTP_REFERER'] = root_url

    get :new

    assert_nil session[:tournament_id]
    assert_nil session[:tournament_friendly_id]
  end

  test "successful create from tournament login page" do
    set_session(@tournament)
    post :create, user: {email: @user.email, password: 'password'}

    assert_redirected_to tournament_admin_path(@tournament)
    assert_equal 'fadeIn', flash[:animate]
  end

  test "successful create from login page" do
    clear_session
    post :create, user: {email: @user.email, password: 'password'}, tournament: @tournament.handle

    assert_redirected_to tournament_admin_path(@tournament)
    assert_equal 'fadeIn', flash[:animate]
  end

  test "unsuccessful login" do
    set_session(@tournament)
    post :create, user: {email: @user.email}

    assert_match 'Log in to manage your tournament', response.body
    assert_equal @tournament.id, session[:tournament_id]
    assert_equal @tournament.handle, session[:tournament_friendly_id]
  end

  test "login with valid user but wrong tournament" do
    tournament = tournaments(:jazz_fest)
    set_session(tournament)

    post :create, user: {email: @user.email, password: 'password'}

    assert_match 'Log in to manage your tournament', response.body
    assert_equal tournament.id, session[:tournament_id]
    assert_equal tournament.handle, session[:tournament_friendly_id]
  end

  test "login with a tournament that doesn't exist" do
    clear_session
    post :create, user: {email: @user.email, password: 'password'}, tournament: 'not-a-handle'

    assert_match 'Log in to manage your tournament', response.body
    assert_nil session[:tournament_id]
    assert_nil session[:tournament_friendly_id]
  end

  test "logout clears session" do
    sign_in @user
    set_session(@tournament)

    delete :destroy

    assert_nil session[:tournament_id]
    assert_nil session[:tournament_friendly_id]
  end

  private

  def set_session(tournament)
    session[:tournament_id] = tournament.id
    session[:tournament_friendly_id] = tournament.friendly_id
  end

  def clear_session
    session[:tournament_id] = nil
    session[:tournament_friendly_id] = nil
  end
end
