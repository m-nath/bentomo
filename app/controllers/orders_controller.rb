class OrdersController < ApplicationController

  def index
    @orders = policy_scope(Order)
    @current_orders = current_user.orders.where("date > ?", Time.now).order(date: :desc)
    @past_orders = current_user.orders.where("date < ?", Time.now).order(date: :desc)
  end

  def show
    # @order = policy_scope(Order).find(params[:id])
    @order = current_user.orders.where(state: 'paid').find(params[:id])
    authorize @order
  end

  def create
    @order = Order.new(order_params)
    @plan = Plan.find(params[:plan_id])
    @order.user = current_user
    @order.plan = @plan
    @order.amount = @plan.price
    @order.state = 'pending'
    authorize @order
    if @order.save
      redirect_to new_order_payment_path(@order)
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
    params.require(:order).permit(:user_id, :plan_id, :amount, :date, :request)
  end
end
