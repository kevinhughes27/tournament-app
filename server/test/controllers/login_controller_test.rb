require 'test_helper'

class LoginControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:tournament_user, user: @user, tournament: @tournament)
    set_tournament(@tournament)
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  teardown do
    sign_out @user
  end

  test "subdomain login page" do
    @tournament.update(name: 'No Borders')
    get :new
    assert_match /No Borders/, response.body
  end

  test "generic login page" do
    set_subdomain('www')
    get :new
    assert_response :ok
  end

  test "visit new when already logged in" do
    sign_in @user
    get :new
    assert_response :ok
  end

  test "successful login redirects to tournament" do
    post :create, params: { user: {email: @user.email, password: 'password'} }

    assert_redirected_to admin_path
    assert_equal 'fadeIn', flash[:animate]
  end

  test "successful login with multiple tournaments" do
    tournament = Tournament.create({name: 'Second Tournament', handle: 'second-tournament'})
    TournamentUser.create!(tournament_id: tournament.id, user_id: @user.id)
    assert_equal 2, @user.tournaments.count

    set_subdomain('www')
    post :create, params: { user: {email: @user.email, password: 'password'} }

    assert_redirected_to choose_tournament_path
  end

  test "successful login with no tournaments" do
    @user.tournaments.delete_all
    post :create, params: { user: {email: @user.email, password: 'password'} }
    assert_redirected_to setup_path
  end

  test "unsuccessful login" do
    post :create, params: { user: {email: @user.email} }
    assert_login_error("Invalid Email or password.")
  end

  test "login with valid user but wrong tournament" do
    tournament = FactoryGirl.create(:tournament)
    set_tournament(tournament)

    post :create, params: { user: {email: @user.email, password: 'password'} }

    assert_login_error("Invalid login for tournament.")
  end

  test "login staff bypass" do
    user = FactoryGirl.create(:staff)
    post :create, params: { user: {email: user.email, password: 'password'} }
    assert_redirected_to admin_path
  end

  test "logout" do
    sign_in @user
    delete :destroy
  end

  private

  def assert_login_error(text)
    assert_match 'Log in', response.body, 'did not render the login page'
    error = css_select('.callout-danger > span')
    assert_equal text, error.text.strip
  end
end
