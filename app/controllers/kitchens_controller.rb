class KitchensController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if params[:search].present?
      @kitchens = policy_scope(Kitchen).global_search(params[:search][:query])
    else
      @kitchens = policy_scope(Kitchen).order(name: :desc)
    end

    # @konbinis = Konbini.all
    konbinis = @kitchens.map do |kitchen|
      {
        lat: kitchen.konbini.latitude,
        lng: kitchen.konbini.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { konbini: kitchen.konbini }),
      image_url: helpers.asset_url('konbini.jpg')}
    end
    @markers = konbinis.uniq
  end


  def show
    @kitchen = policy_scope(Kitchen).find(params[:id])
    authorize @kitchen
    p    @konbini = @kitchen.konbini

    # don't touch this -----
    @marker = [{
                 lat: @konbini.latitude,
                 lng: @konbini.longitude,
                 infoWindow: render_to_string(partial: "info_window", locals: { konbini: @konbini }),
                 image_url: helpers.asset_url('konbini.jpg')
    }]
  end

  def new
    @kitchen = Kitchen.new
    authorize @kitchen
    @konbinis = Konbini.all

    @markers = @konbinis.map do |konbini|
      {
        lat: konbini.longitude,
        lng: konbini.latitude,
        infoWindow: render_to_string(partial: "info_window", locals: { konbini: konbini }),
      image_url: helpers.asset_url('konbini.jpg')}
    end
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
    params.require(:kitchen).permit(:name, :description, :konbini_id, :photo, :tag_list)
  end
end
