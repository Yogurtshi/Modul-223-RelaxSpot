class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  around_action :set_paper_trail_whodunnit
  before_action :sign_out_locked_user

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_authentication
    redirect_to new_session_path unless current_user
  end

  def sign_out_locked_user
    return unless current_user&.locked?

    reset_session
    redirect_to new_session_path, alert: "Your account has been locked."
  end

  def user_not_authorized
    render template: "errors/forbidden", status: :forbidden
  end

  def set_paper_trail_whodunnit
    PaperTrail.request(whodunnit: current_user&.id&.to_s) do
      yield
    end
  end
end
