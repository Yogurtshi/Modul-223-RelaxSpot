class CheckInsController < ApplicationController
  before_action :require_authentication

  def new
    @place = Place.find(params[:place_id])
    @active_check_ins = @place.check_ins.active.count
    @check_in = CheckIn.new(place: @place, user: current_user)
    authorize @place, :show?
    authorize @check_in, :create?
  end

  def create
    @place = Place.find(check_in_params[:place_id])
    @active_check_ins = @place.check_ins.active.count
    @check_in = CheckIn.new(place: @place, user: current_user)
    authorize @check_in, :create?

    @check_in = CheckIn.create_with_capacity!(
      place: @place,
      user: current_user,
      expected_minutes: check_in_params[:expected_minutes].to_i
    )

    redirect_to @check_in
  rescue CheckIn::CapacityExceeded, CheckIn::AlreadyCheckedIn => error
    @active_check_ins = @place.check_ins.active.count
    @check_in = CheckIn.new
    @check_in.errors.add(:base, error.message)
    render :new, status: :unprocessable_entity
  end

  def show
    @check_in = current_user.check_ins.find(params[:id])
    authorize @check_in, :show?
  end

  private

  def check_in_params
    params.require(:check_in).permit(:place_id, :expected_minutes)
  end
end
