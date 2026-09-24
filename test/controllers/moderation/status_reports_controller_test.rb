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
    @report = StatusReport.create!(place: @place, user: @moderator, reported_status: :dirty)
    post session_path, params: { email: @moderator.email, password: "password1234" }
  end

  test "moderator can view a pending status report" do
    get "/moderation/status_reports/#{@report.id}"
    assert_response :success
    assert_select "h1", /Status report/i
  end

  test "moderator can approve a status report" do
    post "/moderation/status_reports/#{@report.id}/approve"

    assert_redirected_to "/moderation/status_reports/#{@report.id}"
    assert @report.reload.reviewed
  end

  test "moderator can reject a status report" do
    post "/moderation/status_reports/#{@report.id}/reject"

    assert_redirected_to "/moderation/status_reports/#{@report.id}"
    assert @report.reload.reviewed
  end
end
