require "test_helper"

class StatusReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get status_reports_new_url
    assert_response :success
  end

  test "should get create" do
    get status_reports_create_url
    assert_response :success
  end
end
