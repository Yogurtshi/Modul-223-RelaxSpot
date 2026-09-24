require "test_helper"

class StatusReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Reporter", email: "reporter@example.com", password: "password1234")
    @place = Place.create!(
      name: "Central Park Bench",
      category: :seating,
      latitude: 47.3769,
      longitude: 8.5417,
      capacity: 3,
      proposed_by: @user,
      approved: true
    )
  end

  test "should get new for an authenticated user" do
    post session_path, params: { email: @user.email, password: "password1234" }

    get new_status_report_path(place_id: @place.id)
    assert_response :success
  end

  test "should create a status report" do
    post session_path, params: { email: @user.email, password: "password1234" }

    post status_reports_path, params: {
      place_id: @place.id,
      status_report: { reported_status: "dirty" }
    }

    assert_redirected_to place_path(@place)
    assert_equal "dirty", @place.status_reports.last.reported_status
  end
end
