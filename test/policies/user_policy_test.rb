require "test_helper"

class UserPolicyTest < ActiveSupport::TestCase
  setup do
    @user = User.new(name: "User", email: "user-policy@example.com", password: "password1234")
    @moderator = User.new(name: "Moderator", email: "moderator-policy@example.com", password: "password1234", role: :moderator)
    @admin = User.new(name: "Admin", email: "admin-policy@example.com", password: "password1234", role: :admin)
    @record = User.new(name: "Record", email: "record-policy@example.com", password: "password1234")
  end

  test "admin can administer users" do
    policy = UserPolicy.new(@admin, @record)

    assert policy.index?
    assert policy.show?
    assert policy.update?
    assert policy.promote?
    assert policy.demote?
    assert policy.lock?
    assert policy.unlock?
  end

  test "moderator cannot administer users" do
    assert_not UserPolicy.new(@moderator, @record).index?
    assert_not UserPolicy.new(@moderator, @record).update?
  end

  test "regular and unauthenticated users cannot administer users" do
    assert_not UserPolicy.new(@user, @record).show?
    assert_not UserPolicy.new(nil, @record).show?
  end
end
