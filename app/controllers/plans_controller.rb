class PlansController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  def index
    if params[:search]
      query = params[:search][:query]
      @tags = params[:search][:tags].reject(&:blank?) if params[:search][:tags].present?

      if query.present? && @tags != nil
        @plans = policy_scope(Plan).global_search(query).tagged_with(@tags)
      elsif query.present?
        @plans = policy_scope(Plan).global_search(query)
      elsif @tags.any?
        @plans = policy_scope(Plan).tagged_with(@tags)
      end
    elsif params[:tag].present?
      @plans = policy_scope(Plan).tagged_with(params[:tag])
    else
      @plans = policy_scope(Plan)
    end

    konbinis = @plans.map do |plan|
      {
        lat: plan.kitchen.konbini.latitude,
        lng: plan.kitchen.konbini.longitude,
        infoWindow: render_to_string(partial: "shared/info_window", locals: { konbini: plan.kitchen.konbini }),
        image_url: helpers.asset_url('konbini.jpg')
    }
    end
    @markers = konbinis.uniq
  end

  def tagged
    if params[:tag].present?
      @plans = policy_scope(Plan).tagged_with(params[:tag])
    else
      @plans = policy_scope(Plan)
    end
  end

  def show
    @plan = policy_scope(Plan).find(params[:id])
    @order = Order.new
    @related_plans = @plan.find_related_tags
    @konbini = @plan.kitchen.konbini

    @marker = [{
                 lat: @konbini.latitude,
                 lng: @konbini.longitude,
                 infoWindow: render_to_string(partial: "shared/info_window", locals: { konbini: @konbini }),
                 image_url: helpers.asset_url('konbini.jpg')
    }]
  end

  def new
    @kitchen = Kitchen.find(params[:kitchen_id])
    @plan = Plan.new(
      kitchen: @kitchen
      )
    authorize @plan
  end

  def create
    @plan = Plan.new(plan_params)
    @kitchen = Kitchen.find(params[:kitchen_id])
    @plan.kitchen = @kitchen
    @plan.kitchen.user = current_user
    authorize @plan
    if @plan.save
      redirect_to plan_path(@plan)
    else
      render :new
    end
  end

  def plan_params
    params.require(:plan).permit(:name, :description, :photo, :tag_list, :price)
  end
end
