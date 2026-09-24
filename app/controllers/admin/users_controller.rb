class Admin::UsersController < ApplicationController
  before_action :require_authentication
  before_action :ensure_admin
  before_action :set_user, only: [ :show, :promote, :demote, :lock, :unlock ]

  def index
    @users = User.order(:name)
  end

  def show
  end

  def promote
    @user.update!(role: :moderator)
    redirect_to admin_user_path(@user), notice: "User promoted to moderator."
  end

  def demote
    @user.update!(role: :user)
    redirect_to admin_user_path(@user), notice: "User demoted to user."
  end

  def lock
    @user.update!(locked: true)
    redirect_to admin_user_path(@user), notice: "User locked."
  end

  def unlock
    @user.update!(locked: false)
    redirect_to admin_user_path(@user), notice: "User unlocked."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_admin
    redirect_to new_session_path unless current_user&.admin?
  end
end
