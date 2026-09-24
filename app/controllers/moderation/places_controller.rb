class Moderation::PlacesController < ApplicationController
  before_action :require_authentication
  before_action :ensure_moderator
  before_action :set_place, only: [ :show, :edit, :update, :approve, :reject, :unlock ]
  before_action :ensure_not_locked_by_other_moderator, only: [ :edit, :update, :unlock ]

  def show
  end

  def edit
    if @place.locked_by_id.blank? || @place.locked_by_id == current_user.id
      @place.update!(locked_by: current_user, locked_at: Time.current)
    end
  end

  def update
    if @place.update(place_params)
      @place.update!(locked_by: nil, locked_at: nil)
      redirect_to moderation_place_path(@place), notice: "Place updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def approve
    @place.update!(approved: true)
    redirect_to moderation_place_path(@place), notice: "Place approved."
  end

  def reject
    @place.update!(approved: false)
    redirect_to moderation_place_path(@place), notice: "Place rejected."
  end

  def unlock
    @place.update!(locked_by: nil, locked_at: nil)
    redirect_to moderation_place_path(@place), notice: "Place lock released."
  end

  private

  def set_place
    @place = Place.find(params[:id])
  end

  def ensure_moderator
    redirect_to new_session_path unless current_user&.moderator? || current_user&.admin?
  end

  def ensure_not_locked_by_other_moderator
    return if @place.locked_by_id.blank?
    return if @place.locked_by_id == current_user.id

    if @place.locked_at.present? && Time.current - @place.locked_at < 5.minutes
      head :forbidden
      return
    end

    @place.update!(locked_by: nil, locked_at: nil)
  end

  def place_params
    params.require(:place).permit(:name, :category, :latitude, :longitude, :capacity, :opening_hours, :status)
  end
end
