class Moderation::DashboardsController < ApplicationController
  before_action :require_authentication

  def show
    authorize current_user, :moderate?
    @recent_activity = PaperTrail::Version
      .includes(:item)
      .order(created_at: :desc)
      .limit(20)
    activity_user_ids = @recent_activity.filter_map(&:whodunnit)
    @activity_users = User.where(id: activity_user_ids).index_by { |user| user.id.to_s }
    @users = User.order(:name)
    @pending_places = Place.where(approved: false).includes(:proposed_by).order(created_at: :desc)
    @pending_status_reports = StatusReport.where(reviewed: false).includes(:place, :user).order(created_at: :desc)
  end
end
