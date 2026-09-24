class Moderation::DashboardsController < ApplicationController
  before_action :require_authentication

  def show
    authorize current_user, :moderate?
    @recent_activity = PaperTrail::Version
      .includes(:item)
      .order(created_at: :desc)
      .limit(20)
    @users = User.order(:name)
    @pending_places = Place.where(approved: false).includes(:proposed_by).order(created_at: :desc)
    @pending_status_reports = StatusReport.where(reviewed: false).includes(:place, :user).order(created_at: :desc)
  end

end
