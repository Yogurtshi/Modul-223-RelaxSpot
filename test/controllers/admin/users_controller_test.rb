require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create!(
      name: "Admin User",
      email: "admin@example.com",
      password: "password1234",
      role: :admin
    )

    @user = User.create!(
      name: "Regular User",
      email: "regular@example.com",
      password: "password1234",
      role: :user
    )

    post session_path, params: {
      email: @admin.email,
      password: "password1234"
    }
  end

  test "admin can list users" do
    get "/admin/users"

    assert_response :success
    assert_select "h1", /Users/i
  end

  test "admin can promote a user to moderator" do
    post "/admin/users/#{@user.id}/promote"

    assert_redirected_to "/admin/users/#{@user.id}"
    assert @user.reload.moderator?
  end

  test "admin can lock a user account" do
    post "/admin/users/#{@user.id}/lock"

    assert_redirected_to "/admin/users/#{@user.id}"
    assert @user.reload.locked
  end

  test "admin can edit user details" do
    get edit_admin_user_path(@user)

    assert_response :success
    assert_select "h1", /Edit Regular User/

    patch admin_user_path(@user), params: {
      user: { name: "Updated User", email: "updated@example.com" }
    }

    assert_redirected_to admin_user_path(@user)
    assert_equal "Updated User", @user.reload.name
    assert_equal "updated@example.com", @user.email
  end

  test "admin sees validation errors when updating invalid user details" do
    patch admin_user_path(@user), params: {
      user: { name: "", email: "updated@example.com" }
    }

    assert_response :unprocessable_entity
    assert_select ".form-errors"
    assert_equal "Regular User", @user.reload.name
  end

  test "regular user cannot access user administration" do
    post session_path, params: {
      email: @user.email,
      password: "password1234"
    }

    get "/admin/users"

    assert_response :forbidden
    assert_select "h1", /do not have permission/i
  end

  test "moderator cannot access user administration" do
    moderator = User.create!(
      name: "Moderator User",
      email: "moderator@example.com",
      password: "password1234",
      role: :moderator
    )
    post session_path, params: {
      email: moderator.email,
      password: "password1234"
    }

    get "/admin/users"

    assert_response :forbidden
  end

  test "unauthenticated visitor is redirected from user administration" do
    delete session_path
    get "/admin/users"

    assert_redirected_to new_session_url
  end
end
