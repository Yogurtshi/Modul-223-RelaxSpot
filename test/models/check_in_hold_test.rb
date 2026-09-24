require "test_helper"

class CheckInHoldTest < ActiveSupport::TestCase
  test "expired holds are not active" do
    hold = CheckInHold.create!(
      place: places(:one),
      user: users(:one),
      expires_at: 1.minute.ago
    )

    assert_not hold.active?
    assert_not_includes CheckInHold.active, hold
  end

  test "claim refreshes an existing user's hold" do
    place = places(:one)
    user = users(:one)
    hold = CheckInHold.create!(place: place, user: user, expires_at: 1.minute.ago)

    refreshed_hold = CheckInHold.claim!(place: place, user: user)

    assert_equal hold.id, refreshed_hold.id
    assert refreshed_hold.active?
  end
end
