class KitchensController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @kitchen = policy_scope(Kitchen).find(params[:id])
    authorize @kitchen

    @konbinis = Konbini.geocoded
    @markers = @konbinis.map do |konbini|
      {
        lat: konbini.latitude,
        lng: konbini.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { konbini: konbini }),
        image_url: helpers.asset_url('konbini.jpg'),
      }
    end
  end

  def new
    @kitchen = Kitchen.new
    authorize @kitchen
  end

  def create
    @kitchen = Kitchen.new(kitchen_params)
    @kitchen.user = current_user
    authorize @kitchen
    if @kitchen.save
      redirect_to kitchen_path(@kitchen)
    end
  end

  private

  def kitchen_params
    params.require(:kitchen).permit(:name, :description, :photo, :tag_list)
  end
end
