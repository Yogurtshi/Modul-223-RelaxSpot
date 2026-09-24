class ProfileController < ApplicationController
  before_action :require_authentication

  def show
    @user = current_user
    authorize @user, :show?, policy_class: ProfilePolicy
  end

  def edit
    @user = current_user
    authorize @user, :update?, policy_class: ProfilePolicy
  end

  def update
    @user = current_user
    authorize @user, :update?, policy_class: ProfilePolicy

    if params.dig(:user, :name).present?
      @user.name = params[:user][:name]
    end

    if params.dig(:user, :email).present?
      if !@user.authenticate(params.dig(:user, :current_password).to_s)
        @user.errors.add(:current_password, "is invalid")
        return render :edit, status: :unprocessable_entity
      end

      @user.unconfirmed_email = params[:user][:email]
      @user.confirmation_token = SecureRandom.hex(16)
      Rails.logger.debug(
        "Confirm email: http://localhost:3000/profile/confirm_email/#{@user.confirmation_token}"
      )
    end

    if params.dig(:user, :password).present?
      if !@user.authenticate(params.dig(:user, :current_password).to_s)
        @user.errors.add(:current_password, "is invalid")
        return render :edit, status: :unprocessable_entity
      end

      @user.password = params[:user][:password]
    end

    if @user.save
      redirect_to profile_path, notice: "Profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_email
    @user = User.find_by(confirmation_token: params[:token])
    return redirect_to profile_path, alert: "Invalid confirmation token." if @user.nil?
    authorize @user, :confirm_email?, policy_class: ProfilePolicy

    @user.email = @user.unconfirmed_email
    @user.unconfirmed_email = nil
    @user.confirmation_token = nil

    @user.save!
    redirect_to profile_path, notice: "Email confirmed."
  end
end
