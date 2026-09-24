class Admin::UsersController < ApplicationController
  before_action :require_authentication
  before_action :set_user, only: [ :show, :promote, :demote, :lock, :unlock ]

  def index
    authorize User
    @users = User.order(:name)
  end

  def show
    authorize @user
  end

  def promote
    authorize @user, :promote?
    @user.update!(role: :moderator)
    redirect_to admin_user_path(@user), notice: "User promoted to moderator."
  end

  def demote
    authorize @user, :demote?
    @user.update!(role: :user)
    redirect_to admin_user_path(@user), notice: "User demoted to user."
  end

  def lock
    authorize @user, :lock?
    @user.update!(locked: true)
    redirect_to admin_user_path(@user), notice: "User locked."
  end

  def unlock
    authorize @user, :unlock?
    @user.update!(locked: false)
    redirect_to admin_user_path(@user), notice: "User unlocked."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
