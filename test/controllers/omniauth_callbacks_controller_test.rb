require 'test_helper'

class OmniauthCallbacksControllerTest < ActionController::TestCase

  setup do
    @user = users(:kevin)
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    @request.env["omniauth.origin"] = "http://no-borders.ultimate-tournament.io"
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "auth callback for new user redirects to tournament setup" do
    @request.env["omniauth.auth"] = OmniAuth.config.add_mock(:google_oauth2, {
      provider: 'google',
      uid: '12345',
      info: {
        email: 'newuser@example.com'
      }
    })

    assert_difference 'User.count', +1 do
      get :google_oauth2
      assert_redirected_to setup_path
    end
  end

  test "auth callback for existing user redirects to tournament" do
    @request.env["omniauth.auth"] = OmniAuth.config.add_mock(:google_oauth2, {
      provider: 'google',
      uid: '12345',
      info: {
        email: @user.email
      }
    })

    assert_no_difference 'User.count' do
      get :google_oauth2
      assert_redirected_to admin_url(subdomain: @tournament.handle)
    end
  end

  test "auth callback for existing user with multiple tournaments redirects to tournament choose page" do
    tournament = Tournament.create({name: 'Second Tournament', handle: 'second-tournament'})
    TournamentUser.create!(tournament_id: tournament.id, user_id: @user.id)
    assert_equal 2, @user.tournaments.count

    @request.env["omniauth.origin"] = "http://www.ultimate-tournament.io"
    @request.env["omniauth.auth"] = OmniAuth.config.add_mock(:google_oauth2, {
      provider: 'google',
      uid: '12345',
      info: {
        email: @user.email
      }
    })

    assert_no_difference 'User.count' do
      get :google_oauth2
      assert_redirected_to choose_tournament_path
    end
  end

  test "auth callback for existing user with no tournaments" do
    @user.tournaments.delete_all
    @request.env["omniauth.auth"] = OmniAuth.config.add_mock(:google_oauth2, {
      provider: 'google',
      uid: '12345',
      info: {
        email: @user.email
      }
    })

    get :google_oauth2
    assert_redirected_to setup_path
  end

  test "auth callback for existing user with no auth type creates new UserAuthentication" do
    @request.env["omniauth.auth"] = OmniAuth.config.add_mock(:google_oauth2, {
      provider: 'google',
      uid: '12345',
      info: {
        email: @user.email
      }
    })

    assert_difference 'UserAuthentication.count', +1 do
      get :google_oauth2
    end
  end

  test "auth callback for existing user with no auth doesn't change password" do
    @request.env["omniauth.auth"] = OmniAuth.config.add_mock(:google_oauth2, {
      provider: 'google',
      uid: '12345',
      info: {
        email: @user.email
      }
    })

    user_password = @user.encrypted_password
    get :google_oauth2
    assert_equal user_password,  @user.reload.encrypted_password
  end

  test "facebook auth callback" do
    @request.env["omniauth.auth"] = OmniAuth.config.add_mock(:facebook, {
      provider: 'facebook',
      uid: '12345',
      info: {
        email: 'newuser@example.com'
      }
    })

    get :facebook
    assert_redirected_to setup_path
  end
end
