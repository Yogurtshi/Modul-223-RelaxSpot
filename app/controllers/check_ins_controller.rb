class CheckInsController < ApplicationController
  before_action :require_authentication

  def new
    @place = Place.find(params[:place_id])
    @check_in = CheckIn.new
  end

  def create
    @place = Place.find(check_in_params[:place_id])

    @check_in = CheckIn.create_with_capacity!(
      place: @place,
      user: current_user,
      expected_minutes: check_in_params[:expected_minutes].to_i
    )

    redirect_to @check_in
  rescue CheckIn::CapacityExceeded => error
    @check_in = CheckIn.new
    @check_in.errors.add(:base, error.message)
    render :new, status: :unprocessable_entity
  end

  def show
    @check_in = current_user.check_ins.find(params[:id])
  end

  private

  def check_in_params
    params.require(:check_in).permit(:place_id, :expected_minutes)
  end
end
