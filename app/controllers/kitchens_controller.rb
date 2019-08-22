class KitchensController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if params[:search]
      query = params[:search][:query]
      tags = params[:search][:tags].reject(&:blank?)

      if query.present? && tags.any?
        @kitchens = policy_scope(Kitchen).global_search(query).tagged_with(tags)
      elsif query.present?
        @kitchens = policy_scope(Kitchen).global_search(query)
      elsif tags.any?
        @kitchens = policy_scope(Kitchen).tagged_with(tags)
      end
    else
      @kitchens = policy_scope(Kitchen)
    end
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
