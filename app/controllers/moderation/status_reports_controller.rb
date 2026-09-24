class Moderation::StatusReportsController < ApplicationController
  before_action :require_authentication

  def show
    set_status_report
    authorize @status_report, :show?
  end

  def edit
    set_status_report
    authorize @status_report, :update?
  end

  def update
    set_status_report
    authorize @status_report, :update?

    if @status_report.update(status_report_params)
      redirect_to moderation_status_report_path(@status_report), notice: "Status report updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def approve
    set_status_report
    authorize @status_report, :approve?
    @status_report.update!(reviewed: true)

    place_updates = { status: @status_report.reported_status }
    if @status_report.reported_opening_hours.present?
      place_updates[:opening_hours] = @status_report.reported_opening_hours
    end
    @status_report.place.update!(place_updates)

    redirect_to moderation_status_report_path(@status_report), notice: "Status report approved."
  end

  def reject
    set_status_report
    authorize @status_report, :reject?
    @status_report.update!(reviewed: true)

    redirect_to moderation_status_report_path(@status_report), notice: "Status report rejected."
  end

  private

  def set_status_report
    @status_report = StatusReport.find(params[:id])
  end

  def status_report_params
    params.require(:status_report).permit(:reported_status, :reported_opening_hours)
  end
end
