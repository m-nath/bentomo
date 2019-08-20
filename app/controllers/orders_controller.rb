class OrdersController < ApplicationController
  def index
    @orders = policy_scope(Order).where(user: current_user).order(date: :desc)
    # @orders = Order.all.order(date: :desc).where(user: current_user)
    @coming_orders = @orders.select do |order|
      authorize order
      order.date.to_date - Date.today >= 0
    end

    @history_orders = @orders.select do |order|
      authorize order
      order.date.to_date - Date.today < 0
    end
  end

  def show
    @order = policy_scope(Order).find(params[:id])
  end

  def create
    @order = Order.new(order_params)
    @plan = Plan.find(params[:plan_id])
    @order.user = current_user
    @order.plan = @plan
    authorize @order
    if @order.save
      redirect_to plan_path(@plan)
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    authorize @order
    @order.update(order_params)
    redirect_to plan_path(@order.plan)
  end

  private

  def order_params
    params.require(:order).permit(:user_id, :plan_id, :amount)
  end
end
