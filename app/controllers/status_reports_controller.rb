class StatusReportsController < ApplicationController
  before_action :require_authentication

  def new
    @place = Place.find(params[:place_id])
    @status_report = StatusReport.new(place: @place)
    authorize @place, :show?
    authorize @status_report, :create?
  end

  def create
    @place = Place.find(params[:place_id])
    @status_report = @place.status_reports.build(status_report_params)
    @status_report.user = current_user
    authorize @status_report, :create?

    if @status_report.save
      redirect_to place_path(@place), notice: "Status report submitted successfully."
    else
      flash.now[:alert] = @status_report.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  private

  def status_report_params
    params.require(:status_report).permit(:reported_status, :reported_opening_hours)
  end
end
