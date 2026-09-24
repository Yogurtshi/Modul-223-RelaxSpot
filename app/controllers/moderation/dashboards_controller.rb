class Moderation::DashboardsController < ApplicationController
  before_action :require_authentication
  before_action :ensure_moderator

  def show
    @recent_activity = PaperTrail::Version
      .includes(:item)
      .order(created_at: :desc)
      .limit(20)
    @users = User.order(:name)
    @pending_places = Place.where(approved: false).includes(:proposed_by).order(created_at: :desc)
    @pending_status_reports = StatusReport.where(reviewed: false).includes(:place, :user).order(created_at: :desc)
  end

  private

  def ensure_moderator
    redirect_to new_session_path unless current_user&.moderator? || current_user&.admin?
  end
end
