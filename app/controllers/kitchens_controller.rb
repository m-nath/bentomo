class KitchensController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @kitchen = policy_scope(Kitchen).find(params[:id])
    authorize @kitchen
  end

  def new
    @kitchen = Kitchen.new
    authorize @kitchen
  end


  private

  def kitchen_params
  params.require(:kitchen).permit(:name, :description, :photo, :tag_list)
  end

end
