require 'test_helper'

class SignupControllerTest < ActionController::TestCase
  setup do
     @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "signup create responds to json" do
    post :create, user: {email: 'bob@bob.com', password: 'password'}, format: :json
    assert_response :created
    assert_equal 'bob@bob.com', response_json['email']
  end

  test "signup create with errors" do
    user = users(:kevin)
    post :create, user: {email: user.email, password: 'password'}, format: :json
    assert_response :unprocessable_entity
    assert_equal ['has already been taken'], response_json['errors']['email']
  end
end
