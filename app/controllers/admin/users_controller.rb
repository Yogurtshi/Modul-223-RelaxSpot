class Admin::UsersController < ApplicationController
  before_action :require_authentication
  before_action :set_user, only: [ :show, :edit, :update, :promote, :demote, :lock, :unlock ]

  def index
    authorize User
    @users = User.order(:name)
  end

  def show
    authorize @user
  end

  def edit
    authorize @user, :update?
  end

  def update
    authorize @user, :update?

    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User details updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def promote
    authorize @user, :promote?
    @user.paper_trail_event = "promoted"
    @user.update!(role: :moderator)
    redirect_to admin_user_path(@user), notice: "User promoted to moderator."
  end

  def demote
    authorize @user, :demote?
    @user.paper_trail_event = "demoted"
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

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
