class KitchensController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # if params[:search].present?
    #   @kitchens = policy_scope(Kitchen).global_search(params[:search][:query])
    # else
    #   @kitchens = policy_scope(Kitchen).order(name: :desc)
    # end
    if params[:search]
      query = params[:search][:query]
      @tags = params[:search][:tags].reject(&:blank?) if params[:search][:tags].present?

      if query.present? && @tags != nil
        @kitchens = policy_scope(Kitchen).global_search(query).tagged_with(@tags)
      elsif query.present?
        @kitchens = policy_scope(Kitchen).global_search(query)
      elsif @tags.any?
        @kitchens = policy_scope(Kitchen).tagged_with(@tags)
      end
    elsif params[:tag].present?
      @kitchens = policy_scope(Kitchen).tagged_with(params[:tag])
    else
      @kitchens = policy_scope(Kitchen)
    end

    # if user_signed_in?
    #   @user = current_user
    #   locations = @user.locations
    #   search_locations = []
    #   locations.map do |location|
    #     search = Konbini.near(location, 2)
    #     search_locations << search
    #   end
    #    konbinis = search_locations.map do |search_location|
    #    search_location.map do |search|
    #     {
    #       lat: search.latitude,
    #       lng: search.longitude,
    #       infoWindow: render_to_string(partial: "info_window", locals: { kitchen: search_location }),
    #       image_url: helpers.asset_url('konbini.jpg')
    #     }
    #     end
    #   end
    #   konbinim = konbinis.flatten
    #   @markers = konbinim.uniq

    if user_signed_in?
      @user = current_user
      location = @user.locations.first
      search = Konbini.near(location, 1)
      konbinis = search.map do |search_location|
        {
          lat: search_location.latitude,
          lng: search_location.longitude,
          infoWindow: render_to_string(partial: "info_window", locals: { kitchen: search_location }),
          image_url: helpers.asset_url('konbini.jpg')
        }
      end
      @markers = konbinis.uniq
    else
      konbinis = @kitchens.map do |kitchen|
        {
          lat: kitchen.konbini.latitude,
          lng: kitchen.konbini.longitude,
          infoWindow: render_to_string(partial: "info_window", locals: { kitchen: kitchen.konbini }),
          image_url: helpers.asset_url('konbini.jpg')
        }
      end
      @markers = konbinis.uniq
    end
  end

  def tagged
    if params[:tag].present?
      @kitchens = policy_scope(Kitchen).tagged_with(params[:tag])
    else
      @kitchens = policy_scope(Kitchen)
    end
  end

  def show
    @kitchen = policy_scope(Kitchen).find(params[:id])
    authorize @kitchen
    @plan = @kitchen.plans
    @konbini = @kitchen.konbini

    # don't touch this -----
    @marker = [{
                 lat: @konbini.latitude,
                 lng: @konbini.longitude,
                 infoWindow: render_to_string(partial: "shared/info_window", locals: { konbini: @konbini }),
                 image_url: helpers.asset_url('konbini.jpg')
    }]
  end


  def new
    @kitchen = Kitchen.new
    authorize @kitchen
    @konbinis = Konbini.all

    if current_user.locations.exists?
      @user = current_user
      location = @user.locations.first
      search = Konbini.near(location, 1)
      konbinis = search.map do |search_location|
        {
          lat: search_location.latitude,
          lng: search_location.longitude,
          infoWindow: render_to_string(partial: "shared/info_window", locals: { konbini: search_location }),
          image_url: helpers.asset_url('konbini.jpg')
        }
      end
      @markers = konbinis.uniq
    else
      konbinis = @konbinis.map do |konbini|
        {
          lat: konbini.latitude,
          lng: konbini.longitude,
          infoWindow: render_to_string(partial: "info_window", locals: { konbini: konbini }),
          image_url: helpers.asset_url('konbini.jpg')
        }
      end
      @markers = konbinis.uniq
      # @markers = @konbinis.map do |konbini|
      #   {
      #     lat: konbini.latitude,
      #     lng: konbini.longitude,
      #     infoWindow: render_to_string(partial: "shared/info_window", locals: { konbini: konbini }),
      #   image_url: helpers.asset_url('konbini.jpg')}
      # end
    end
  end

  def create
    @kitchen = Kitchen.new(kitchen_params)
    @kitchen.user = current_user
    authorize @kitchen
    if @kitchen.save
      redirect_to kitchen_path(@kitchen)
    else
      render :new
    end
  end

  def edit
    @kitchen = Kitchen.find(params[:id])
    authorize @kitchen
  end

  def update
    @kitchen = Kitchen.find(params[:id])
    @kitchen.update(kitchen_params)
    authorize @kitchen
    redirect_to kitchen_path(@kitchen)
  end

  def destroy
    @kitchen = Kitchen.find(params[:id])
    authorize @kitchen
    @kitchen.destroy
    redirect_to kitchens_path
  end

  private

  def kitchen_params
    params.require(:kitchen).permit(:name, :description, :konbini_id, :photo, :tag_list)
  end
end
