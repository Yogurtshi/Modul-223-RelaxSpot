require "test_helper"

class StatusReportPolicyTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Regular User", email: "user@example.com", password: "password1234")
    @moderator = User.new(name: "Moderator", email: "moderator@example.com", password: "password1234", role: :moderator)
    @admin = User.new(name: "Admin", email: "admin@example.com", password: "password1234", role: :admin)
    @report = StatusReport.new(place: Place.new(name: "Test Place", latitude: 47.3769, longitude: 8.5417, capacity: 3), user: @user)
  end

  test "moderator can review status reports" do
    assert StatusReportPolicy.new(@moderator, @report).approve?
  end

  test "admin can manage status reports" do
    assert StatusReportPolicy.new(@admin, @report).reject?
  end

  test "regular user cannot approve status reports" do
    assert_not StatusReportPolicy.new(@user, @report).approve?
  end

  test "unauthenticated visitor cannot create status reports" do
    assert_not StatusReportPolicy.new(nil, @report).create?
  end
end
