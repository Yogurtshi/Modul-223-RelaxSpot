class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate_by(
      email: params[:email],
      password: params[:password]
    )

    if user && !user.locked?
      session[:user_id] = user.id
      redirect_to places_path
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path
  end
end
