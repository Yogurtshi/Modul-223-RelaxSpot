require "test_helper"

class CheckInsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Check-in User",
      email: "check-in-user@example.com",
      password: "secure-password"
    )

    post session_url, params: {
      email: @user.email,
      password: "secure-password"
    }
  end

  test "should get new" do
    get new_check_in_url, params: {
      place_id: places(:one).id
    }

    assert_response :success
  end

  test "disables check-in submission when the place is full" do
    place = places(:one)
    place.update!(capacity: 1)
    CheckIn.create!(
      place: place,
      user: User.create!(name: "Full User", email: "full-user@example.com", password: "secure-password"),
      started_at: 10.minutes.ago,
      ends_at: 20.minutes.from_now
    )

    get new_check_in_url, params: { place_id: place.id }

    assert_response :success
    assert_select ".capacity-notice", text: "This place is currently full."
    assert_select "input[type=submit][disabled][value='Check in']"
  end

  test "should create check-in" do
    assert_difference("CheckIn.count", 1) do
      post check_ins_url, params: {
        check_in: {
          place_id: places(:one).id,
          expected_minutes: 30
        }
      }
    end

    assert_redirected_to check_in_url(CheckIn.order(:created_at).last)
  end

  test "should get own check-in" do
    check_in = CheckIn.create!(
      place: places(:one),
      user: @user,
      started_at: Time.current,
      ends_at: 30.minutes.from_now
    )

    get check_in_url(check_in)

    assert_response :success
  end

  test "cannot view another user's check-in" do
    other_user = User.create!(
      name: "Other Check-in User",
      email: "other-check-in-user@example.com",
      password: "secure-password"
    )
    check_in = CheckIn.create!(
      place: places(:one),
      user: other_user,
      started_at: Time.current,
      ends_at: 30.minutes.from_now
    )

    get check_in_url(check_in)

    assert_response :not_found
  end

  test "rejects check-in when the place is full" do
    place = places(:one)
    place.update!(capacity: 1)

    other_user = User.create!(
      name: "Capacity User",
      email: "capacity-user@example.com",
      password: "secure-password"
    )

    CheckIn.create!(
      place: place,
      user: other_user,
      started_at: Time.current,
      ends_at: 30.minutes.from_now
    )

    assert_no_difference("CheckIn.count") do
      post check_ins_url, params: {
        check_in: {
          place_id: place.id,
          expected_minutes: 30
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "rejects a second active check-in at the same place" do
    place = places(:one)

    CheckIn.create!(
      place: place,
      user: @user,
      started_at: Time.current,
      ends_at: 30.minutes.from_now
    )

    assert_no_difference("CheckIn.count") do
      post check_ins_url, params: {
        check_in: {
          place_id: place.id,
          expected_minutes: 30
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
