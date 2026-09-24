class Moderation::DashboardsController < ApplicationController
  def show
    @recent_activity = PaperTrail::Version
      .includes(:item)
      .order(created_at: :desc)
      .limit(20)
  end
end
