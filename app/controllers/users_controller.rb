class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      PaperTrail::Version.where(item: @user).order(:created_at).last&.update!(whodunnit: @user.id.to_s)
      session[:user_id] = @user.id
      redirect_to places_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
