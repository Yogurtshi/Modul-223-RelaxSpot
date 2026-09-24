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

  test "regular user cannot access user administration" do
    post session_path, params: {
      email: @user.email,
      password: "password1234"
    }

    get "/admin/users"

    assert_response :forbidden
  end
end
