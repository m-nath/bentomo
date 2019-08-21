class OrdersController < ApplicationController

  def index

    # @user = policy_scope(User).where(order:)
    # @orders = policy_scope(User).where(order).order(date: :desc)
    # @coming_orders = @orders.select do |order|
    @orders = policy_scope(Order)
    @current_orders = Order.where(user: current_user).order(date: :desc)
    @past_orders = Order.where(user: current_user).order(date: :asc)
    # order.date.to_date - Date.today >= 0
  end

  # @history_orders = @orders.select do |order|
  #   authorize order
  #   # order.date.to_date - Date.today < 0
  # end

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
    params.require(:order).permit(:user_id, :plan_id, :amount, :date)
  end
end
