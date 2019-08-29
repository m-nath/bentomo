class DishPlansController < ApplicationController
  before_action :set_plan

  def create
    @dish_plan = DishPlan.new(dish_plan_params)
    @dish_plan.plan = @plan
    authorize @dish_plan
    if @dish_plan.save
      redirect_to kitchen_path(@plan.kitchen)
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

  def dish_plan_params
    params.require(:dish_plan).permit(:dish_id)
  end
end
