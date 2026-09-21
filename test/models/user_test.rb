require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires a password with at least 12 characters" do
    user = User.new(
      name: "Test User",
      email: "test@example.com",
      password: "short"
    )

    assert_not user.valid?
    assert_includes user.errors[:password], "is too short (minimum is 12 characters)"
  end

  test "normalizes email addresses" do
    user = User.new(
      name: "Test User",
      email: " TEST@EXAMPLE.COM ",
      password: "secure-password"
    )

    assert_equal "test@example.com", user.email
  end

  test "defaults to the user role" do
    user = User.new

    assert user.user?
  end
end
