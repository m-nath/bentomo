class PlansController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  def index
    if params[:search]
      query = params[:search][:query]
      tags = params[:search][:tags].reject(&:blank?)

      if query.present? && tags.any?
        @plans = policy_scope(Plan).global_search(query).tagged_with(tags)
      elsif query.present?
        @plans = policy_scope(Plan).global_search(query)
      elsif tags.any?
        @plans = policy_scope(Plan).tagged_with(tags)
      end
    else
      @plans = policy_scope(Plan)
    end
# raise
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
  end

  def new
    @plan = Plan.new
    authorize @plan
  end

  def create
    @plan = Plan.new(plans_params)
    @plan.user = current_user
    authorize @plan
    if @plan.save
      redirect_to plan_path(@plan)
    else
      render :new
    end
  end

  def plan_params
    params.require(:plan).permit(:name, :description, :photo, :tag_list)
  end
end
