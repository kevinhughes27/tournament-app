require 'test_helper'

class LoginControllerTest < ActionController::TestCase

  setup do
    @user = users(:kevin)
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  teardown do
    sign_out @user
  end

  test "subdomain login page" do
    get :new
    assert_match /#{@tournament.name}/, response.body
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
    post :create, user: {email: @user.email, password: 'password'}

    assert_redirected_to admin_path
    assert_equal 'fadeIn', flash[:animate]
  end

  test "successful login with multiple tournaments" do
    tournament = Tournament.create({name: 'Second Tournament', handle: 'second-tournament'})
    TournamentUser.create!(tournament_id: tournament.id, user_id: @user.id)
    assert_equal 2, @user.tournaments.count

    set_subdomain('www')
    post :create, user: {email: @user.email, password: 'password'}

    assert_redirected_to choose_tournament_path
  end

  test "successful login with no tournaments" do
    @user.tournaments.delete_all
    post :create, user: {email: @user.email, password: 'password'}
    assert_redirected_to setup_path
  end

  test "unsuccessful login" do
    post :create, user: {email: @user.email}
    assert_login_error("Invalid email or password.")
  end

  test "login with valid user but wrong tournament" do
    tournament = tournaments(:jazz_fest)
    set_tournament(tournament)

    post :create, user: {email: @user.email, password: 'password'}

    assert_login_error("Invalid login for tournament.")
  end

  test "logout clears session" do
    sign_in @user
    session[:tournament_id] = @tournament.id
    session[:tournament_friendly_id] = @tournament.friendly_id

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
end
