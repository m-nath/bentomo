class UsersController < ApplicationController

  def edit
    @user = current_user
    authorize @user
    @locations = @user.locations
  end

  def update
    @user = current_user
    @user.update(user_params)
    @user.locations.build
    authorize @user
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :photo, :password, :default_location, :radius, locations_attributes: [:label, :address])
  end
end
