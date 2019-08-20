class OrdersController < ApplicationController
  def index
    @orders = policy_scope(Order).order(date: :desc)
    authorize @order
  end

  def show
    @order = policy_scope(Order).find(params[:id])
  end

  def create
    @order = Order.new(order_params)
    @plan = Plan.find(params[:plan_id])
    @order.user = current_user
    @order.plan = @plan
    if @order.save
      redirect_to plan_path(@plan)
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
