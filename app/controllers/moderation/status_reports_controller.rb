class Moderation::StatusReportsController < ApplicationController
  before_action :require_authentication
  before_action :ensure_moderator

  def show
    @status_report = StatusReport.find(params[:id])
  end

  def approve
    @status_report = StatusReport.find(params[:id])
    @status_report.update!(reviewed: true)
    @status_report.place.update!(status: @status_report.reported_status)

    redirect_to moderation_status_report_path(@status_report), notice: "Status report approved."
  end

  def reject
    @status_report = StatusReport.find(params[:id])
    @status_report.update!(reviewed: true)

    redirect_to moderation_status_report_path(@status_report), notice: "Status report rejected."
  end

  private

  def ensure_moderator
    redirect_to new_session_path unless current_user&.moderator? || current_user&.admin?
  end
end
