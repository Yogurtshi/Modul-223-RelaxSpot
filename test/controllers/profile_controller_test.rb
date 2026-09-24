require "test_helper"

class ProfileControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Test User",
      email: "user@example.com",
      password: "password1234"
    )

    post session_path, params: {
      email: @user.email,
      password: "password1234"
    }
  end

  test "logged in user can view own profile" do
    get "/profile"

    assert_response :success
    assert_select "h1", /Profile/i
  end

  test "logged in user can update their name" do
    patch "/profile", params: {
      user: {
        name: "Updated Name"
      }
    }

    assert_redirected_to "/profile"
    assert_equal "Updated Name", @user.reload.name
  end

  test "user must enter current password to change password" do
    patch "/profile", params: {
      user: {
        current_password: "wrongpassword",
        password: "newpassword1234"
      }
    }

    assert_response :unprocessable_entity
  end

  test "user can request email confirmation" do
    patch "/profile", params: {
      user: {
        email: "new@example.com",
        current_password: "password1234"
      }
    }

    assert_redirected_to "/profile"
    assert_equal "new@example.com", @user.reload.unconfirmed_email
    assert_not_nil @user.confirmation_token
  end

  test "confirmation token updates the email" do
    @user.update!(
      unconfirmed_email: "new@example.com",
      confirmation_token: "abc123"
    )

    get "/profile/confirm_email/abc123"

    assert_redirected_to "/profile"
    assert_equal "new@example.com", @user.reload.email
    assert_nil @user.reload.unconfirmed_email
    assert_nil @user.confirmation_token
  end

  test "invalid confirmation token does not update the email" do
    get "/profile/confirm_email/invalid-token"

    assert_redirected_to "/profile"
    assert_equal "Invalid confirmation token.", flash[:alert]
    assert_equal "user@example.com", @user.reload.email
  end

  test "failed email change does not persist confirmation state" do
    User.create!(
      name: "Existing User",
      email: "existing@example.com",
      password: "password1234"
    )

    patch "/profile", params: {
      user: {
        email: "existing@example.com",
        current_password: "password1234"
      }
    }

    assert_response :unprocessable_entity
    @user.reload
    assert_nil @user.unconfirmed_email
    assert_nil @user.confirmation_token
  end
end
