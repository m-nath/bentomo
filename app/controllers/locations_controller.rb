class LocationsController < ApplicationController
  before_action :set_user

  def create
    @location = Location.new(location_params)
    @location.user = @user
    @location.user = current_user
    authorize @location
    if @location.save
      redirect_to root_path
    else
      flash[:alert] = "Something went wrong."
      render "users/sign_up"
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def location_params
    params.require(:location).permit(:label, :address)
  end
end
