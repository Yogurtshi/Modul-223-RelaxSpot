require "test_helper"

class CheckInTest < ActiveSupport::TestCase
  setup do
    @place = places(:one)
    @place.update!(capacity: 2)
    @user = User.create!(
      name: "Model Test User",
      email: "model-test@example.com",
      password: "password1234"
    )
  end

  test "creates a check-in while capacity remains" do
    check_in = CheckIn.create_with_capacity!(
      place: @place,
      user: @user,
      expected_minutes: 30
    )

    assert check_in.persisted?
    assert_equal @user, check_in.user
  end

  test "raises when the place has no remaining capacity" do
    @place.update!(capacity: 1)
    CheckIn.create!(
      place: @place,
      user: users(:one),
      started_at: Time.current,
      ends_at: 30.minutes.from_now
    )

    assert_raises CheckIn::CapacityExceeded do
      CheckIn.create_with_capacity!(
        place: @place,
        user: @user,
        expected_minutes: 30
      )
    end
  end

  test "raises when the user already has an active check-in at the place" do
    CheckIn.create!(
      place: @place,
      user: @user,
      started_at: Time.current,
      ends_at: 30.minutes.from_now
    )

    assert_raises CheckIn::AlreadyCheckedIn do
      CheckIn.create_with_capacity!(
        place: @place,
        user: @user,
        expected_minutes: 30
      )
    end
  end

  test "rejects a check-in that ends before it starts" do
    check_in = CheckIn.new(
      place: @place,
      user: @user,
      started_at: 30.minutes.from_now,
      ends_at: Time.current
    )

    assert_not check_in.valid?
    assert_includes check_in.errors[:ends_at], "must be after the start time"
  end
end
