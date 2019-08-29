class LocationsController < ApplicationController
  before_action :set_user

  def create
    @location = @user.locations.create(params[:location])
    Location.new(location_params)
    @user = current_user
    @location = @user.locations
    authorize @location
    if @location.save
      redirect_to root_path
    end
  end

  def edit

  end

  def update

  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def location_params
    params.require(:location).permit(:label, :address)
  end
end
