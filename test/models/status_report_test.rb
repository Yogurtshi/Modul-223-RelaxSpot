require "test_helper"

class StatusReportTest < ActiveSupport::TestCase
  setup do
    @report = StatusReport.new(
      place: places(:one),
      user: users(:one),
      reported_status: :dirty
    )
  end

  test "is valid with a place, user, and reported status" do
    assert_predicate @report, :valid?
  end

  test "requires a reported status" do
    @report.reported_status = nil

    assert_not @report.valid?
    assert_includes @report.errors[:reported_status], "can't be blank"
  end

  test "belongs to its place and reporting user" do
    assert_equal places(:one), @report.place
    assert_equal users(:one), @report.user
  end
end
