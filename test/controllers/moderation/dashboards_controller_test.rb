require "test_helper"

class Moderation::DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get moderation_dashboards_show_url
    assert_response :success
  end
end
