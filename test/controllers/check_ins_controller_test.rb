require "test_helper"

class CheckInsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_check_in_url
    assert_response :success
  end

  test "should create check-in request" do
    post check_ins_url, params: {
      check_in: {
        place_id: places(:one).id,
        expected_minutes: 30
      }
    }

    assert_response :success
  end

  test "should get show" do
    get check_in_url(check_ins(:one))
    assert_response :success
  end
end
