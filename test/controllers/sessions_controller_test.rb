require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Login User",
      email: "login-user@example.com",
      password: "secure-password"
    )
  end

  test "should get new" do
    get new_session_url
    assert_response :success
  end

  test "should log in with valid credentials" do
    post session_url, params: {
      email: @user.email,
      password: "secure-password"
    }

    assert_redirected_to places_url
  end

  test "should reject invalid credentials" do
    post session_url, params: {
      email: @user.email,
      password: "wrong-password"
    }

    assert_response :unprocessable_entity
  end

  test "should log out" do
    post session_url, params: {
      email: @user.email,
      password: "secure-password"
    }

    delete session_url

    assert_redirected_to new_session_url
  end
end
