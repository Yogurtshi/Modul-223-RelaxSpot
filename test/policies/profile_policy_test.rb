require "test_helper"

class ProfilePolicyTest < ActiveSupport::TestCase
  setup do
    @user = User.new(name: "User", email: "profile-policy@example.com", password: "password1234")
    @other_user = User.new(name: "Other", email: "other-profile-policy@example.com", password: "password1234")
  end

  test "user can manage their own profile" do
    policy = ProfilePolicy.new(@user, @user)

    assert policy.show?
    assert policy.update?
    assert policy.confirm_email?
  end

  test "user cannot manage another profile" do
    policy = ProfilePolicy.new(@user, @other_user)

    assert_not policy.show?
    assert_not policy.update?
    assert_not policy.confirm_email?
  end

  test "unauthenticated visitor cannot manage a profile" do
    assert_not ProfilePolicy.new(nil, @user).show?
  end
end
