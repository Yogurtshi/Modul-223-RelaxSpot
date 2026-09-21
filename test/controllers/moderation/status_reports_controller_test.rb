require "test_helper"

class Moderation::StatusReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get moderation_status_reports_show_url
    assert_response :success
  end

  test "should get approve" do
    get moderation_status_reports_approve_url
    assert_response :success
  end

  test "should get reject" do
    get moderation_status_reports_reject_url
    assert_response :success
  end
end
