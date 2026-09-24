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

    user = User.find_by!(email: "new-user@example.com")
    version = PaperTrail::Version.where(item: user).order(:created_at).last
    assert_equal "create", version.event
    assert_equal user.id.to_s, version.whodunnit
  end
end
