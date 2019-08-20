class UsersController < ApplicationController

  def edit
    @user = current_user
    authorize @user
    @locations = @user.locations
  end
end
