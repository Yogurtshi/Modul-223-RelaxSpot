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

  test "rejects check-in when the place is full" do
    place = places(:one)
    place.update!(capacity: 1)

    CheckIn.create!(
      place: place,
      user: users(:one),
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
