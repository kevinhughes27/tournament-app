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

  test "visit new when already logged in" do
    sign_in @user
    get :new
    assert_response :ok
  end

  test "successful create from tournament login page" do
    set_session(@tournament)
    post :create, user: {email: @user.email, password: 'password'}

    assert_redirected_to tournament_admin_path(@tournament)
    assert_equal 'fadeIn', flash[:animate]
  end

  test "successful login" do
    clear_session
    post :create, user: {email: @user.email, password: 'password'}, tournament: @tournament.handle

    assert_redirected_to tournament_admin_path(@tournament)
    assert_equal 'fadeIn', flash[:animate]
  end

  test "successful login with no tournaments" do
    clear_session
    @user.tournaments.delete_all
    post :create, user: {email: @user.email, password: 'password'}, tournament: @tournament.handle
    assert_redirected_to setup_path
  end

  test "unsuccessful login" do
    set_session(@tournament)
    post :create, user: {email: @user.email}

    assert_login_error("Invalid email or password.")
    assert_equal @tournament.id, session[:tournament_id]
    assert_equal @tournament.handle, session[:tournament_friendly_id]
  end

  test "login with valid user but wrong tournament" do
    tournament = tournaments(:jazz_fest)
    set_session(tournament)

    post :create, user: {email: @user.email, password: 'password'}

    assert_login_error("Invalid login for tournament.")
    assert_equal tournament.id, session[:tournament_id]
    assert_equal tournament.handle, session[:tournament_friendly_id]
  end

  test "login with a tournament that doesn't exist" do
    clear_session
    post :create, user: {email: @user.email, password: 'password'}, tournament: 'not-a-handle'

    assert_login_error("Invalid tournament.")
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

  def assert_login_error(text)
    assert_match 'Log in', response.body, 'did not render the login page'
    error = css_select('.callout-danger > span')
    assert_equal text, error.text.strip
  end

  def set_session(tournament)
    session[:tournament_id] = tournament.id
    session[:tournament_friendly_id] = tournament.friendly_id
  end

  def clear_session
    session[:tournament_id] = nil
    session[:tournament_friendly_id] = nil
  end
end
