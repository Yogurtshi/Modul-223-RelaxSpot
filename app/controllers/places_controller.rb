class PlacesController < ApplicationController
  before_action :require_authentication, only: [ :new, :create ]
  def index
    @places = Place.where(approved: true).order(:name)
    @active_check_ins_by_place = CheckIn.active.where(place_id: @places).group(:place_id).count
  end

  def show
    @place = Place.find(params[:id])
  end

  def new
    @place = Place.new
  end

  def create
    @place = current_user.proposed_places.build(place_params)

    if @place.save
      redirect_to places_path, notice: "Place suggestion submitted for review."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def place_params
    params.require(:place).permit(
      :name,
      :category,
      :status,
      :latitude,
      :longitude,
      :capacity,
      :opening_hours
    )
  end
end
