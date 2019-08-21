class PlansController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if params[:query].present?
      @plans = policy_scope(Plan).global_search(params[:query])
    else
      @plans = policy_scope(Plan)
    end
  end

  def show
    @plan = policy_scope(Plan).find(params[:id])
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
end
