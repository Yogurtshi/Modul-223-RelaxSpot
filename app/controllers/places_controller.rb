class PlacesController < ApplicationController
  before_action :require_authentication, only: [ :new, :create ]
  def index
    @search = params[:search].to_s.strip
    @category = params[:category].presence_in(Place.categories.keys)
    @status = params[:status].presence_in(Place.statuses.keys)

    @places = Place.where(approved: true)
    @places = @places.where(category: @category) if @category
    @places = @places.where(status: @status) if @status
    if @search.present?
      escaped_search = Place.sanitize_sql_like(@search.downcase)
      @places = @places.where("LOWER(name) LIKE ?", "%#{escaped_search}%")
    end
    @places = @places.order(:name)
    @active_check_ins_by_place = CheckIn.active.where(place_id: @places).group(:place_id).count
  end

  def show
    @place = Place.find(params[:id])
    @active_check_ins = @place.check_ins.active.count
  end

  def availability
    place = Place.find(params[:id])
    render json: {
      active_count: place.check_ins.active.count,
      capacity: place.capacity
    }
  end

  def new
    @place = Place.new
    authorize @place, :create?
  end

  def create
    @place = current_user.proposed_places.build(place_params)
    authorize @place, :create?

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
