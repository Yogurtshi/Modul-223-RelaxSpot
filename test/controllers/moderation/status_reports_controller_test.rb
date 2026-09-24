require "test_helper"

class Moderation::StatusReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @moderator = User.create!(name: "Moderator User", email: "moderator@example.com", password: "password1234", role: :moderator)
    @place = Place.create!(
      name: "Central Park Bench",
      category: :seating,
      latitude: 47.3769,
      longitude: 8.5417,
      capacity: 3,
      proposed_by: @moderator,
      approved: true
    )
    @report = StatusReport.create!(place: @place, user: @moderator, reported_status: :dirty, reported_opening_hours: "Weekdays, 08:00-16:00")
    post session_path, params: { email: @moderator.email, password: "password1234" }
  end

  test "moderator can view a pending status report" do
    get "/moderation/status_reports/#{@report.id}"
    assert_response :success
    assert_select "h1", @report.place.name
  end

  test "moderator can approve a status report" do
    post "/moderation/status_reports/#{@report.id}/approve"

    assert_redirected_to "/moderation/status_reports/#{@report.id}"
    assert @report.reload.reviewed
    assert_equal "Weekdays, 08:00-16:00", @place.reload.opening_hours
  end

  test "moderator can reject a status report" do
    post "/moderation/status_reports/#{@report.id}/reject"

    assert_redirected_to "/moderation/status_reports/#{@report.id}"
    assert @report.reload.reviewed
  end

  test "moderator can edit a status report" do
    patch "/moderation/status_reports/#{@report.id}", params: {
      status_report: { reported_status: "closed", reported_opening_hours: "Daily, 10:00-18:00" }
    }

    assert_redirected_to "/moderation/status_reports/#{@report.id}"
    assert_equal "closed", @report.reload.reported_status
    assert_equal "Daily, 10:00-18:00", @report.reload.reported_opening_hours
  end
end
