class UsersController < ApplicationController

  def edit
    @user = current_user
    authorize @user
    @locations = @user.locations
  end

  def update
    @user = current_user
    @location = Location.new
    authorize @user
    if !params["user"]["locations_attributes"].nil?
      @locations = @user.locations
      @user.update(user_params)
      @user.locations.build
      new_location = params["user"]["locations_attributes"]["0"]["address"]
      old_location_id = params["user"]["locations_attributes"]["0"]["id"]
      old_location = Location.find(old_location_id)
      if new_location != old_location.address
        new = Location.create!(label: "Work", address: new_location, user_id: current_user.id)
        @user.update(default_location: new.id)
      end
    else
      location_id = params["user"]["default_location"]
      @user.update(default_location: location_id)
    end
    redirect_to root_path
  end


  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :photo, :password, :default_location, :radius, locations_attributes: [:label, :address])
  end
end
