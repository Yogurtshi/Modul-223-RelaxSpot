class CheckInsController < ApplicationController
  before_action :require_authentication

  def new
    @place = Place.find(params[:place_id])
    @active_check_ins = @place.check_ins.active.count
    @active_check_in_holds = @place.check_in_holds.active.count
    @check_in = CheckIn.new(place: @place, user: current_user)
    authorize @place, :show?
    authorize @check_in, :create?
    @check_in_hold = CheckInHold.claim!(place: @place, user: current_user)
  rescue CheckInHold::CapacityExceeded => error
    @check_in_hold = nil
    @check_in = CheckIn.new(place: @place, user: current_user)
    @check_in.errors.add(:base, error.message)
    render :new, status: :unprocessable_entity
  end

  def create
    @place = Place.find(check_in_params[:place_id])
    @active_check_ins = @place.check_ins.active.count
    @active_check_in_holds = @place.check_in_holds.active.count
    @check_in = CheckIn.new(place: @place, user: current_user)
    @check_in_hold = @place.check_in_holds.find_by(user: current_user)
    authorize @check_in, :create?

    @check_in = CheckIn.create_with_capacity!(
      place: @place,
      user: current_user,
      expected_minutes: check_in_params[:expected_minutes].to_i,
      hold: @place.check_in_holds.find_by(user: current_user)
    )

    redirect_to @check_in
  rescue CheckIn::CapacityExceeded, CheckIn::AlreadyCheckedIn => error
    @active_check_ins = @place.check_ins.active.count
    @active_check_in_holds = @place.check_in_holds.active.count
    @check_in = CheckIn.new
    @check_in_hold = nil
    @check_in.errors.add(:base, error.message)
    render :new, status: :unprocessable_entity
  end

  def show
    @check_in = current_user.check_ins.find(params[:id])
    authorize @check_in, :show?
  end

  def cancel_hold
    place = Place.find(params[:place_id])
    place.check_in_holds.find_by(user: current_user)&.destroy!
    redirect_to place_path(place), notice: "Check-in hold released."
  end

  private

  def check_in_params
    params.require(:check_in).permit(:place_id, :expected_minutes)
  end
end
