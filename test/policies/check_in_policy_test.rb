require "test_helper"

class CheckInPolicyTest < ActiveSupport::TestCase
  setup do
    @user = User.new(name: "User", email: "check-in-policy@example.com", password: "password1234")
    @other_user = User.new(name: "Other", email: "other-check-in-policy@example.com", password: "password1234")
    @place = Place.new(name: "Place", latitude: 47.3769, longitude: 8.5417, capacity: 3, approved: true, proposed_by: @user)
  end

  test "user can create a check-in at an approved place" do
    check_in = CheckIn.new(place: @place, user: @user)

    assert CheckInPolicy.new(@user, check_in).create?
  end

  test "user cannot view another user's check-in" do
    check_in = CheckIn.new(place: @place, user: @other_user)

    assert_not CheckInPolicy.new(@user, check_in).show?
  end

  test "unauthenticated visitor cannot create a check-in" do
    check_in = CheckIn.new(place: @place, user: nil)

    assert_not CheckInPolicy.new(nil, check_in).create?
  end
end