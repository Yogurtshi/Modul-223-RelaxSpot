require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count", 1) do
      post users_url, params: {
        user: {
          name: "New User",
          email: "new-user@example.com",
          password: "secure-password",
          password_confirmation: "secure-password"
        }
      }
    end

    assert_redirected_to places_url
  end
end
