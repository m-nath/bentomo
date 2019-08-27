class OrdersController < ApplicationController

  def index
    @orders = policy_scope(Order)
    @current_orders = current_user.orders.where("date > ?", Time.now).order(date: :desc)
    @past_orders = current_user.orders.where("date < ?", Time.now).order(date: :desc)
    if current_user.kitchen.present?
      received_orders = []
      current_user.kitchen.plans.each do |plan|
        plan.orders.each do |order|
        received_orders << order if order.date > Time.now && order.state =='paid'
        end
      end
      return @received_orders = received_orders
    end


    # #if no chat history
    # if ChatRoom.all.select{|chat_room| chat_room.users.include?(current_user) && chat_room.users.include?(order.kitchen.user)}.nil?
    #   @chat_room = ChatRoom.create
    # #if chated before
    # else
    #   @chat_room = ChatRoom.all.select{|chat_room| chat_room.users.include?(current_user) && chat_room.users.include?(order.kitchen.user)}.first
    # end

  end

  def show
    # @order = policy_scope(Order).find(params[:id])
    @order = current_user.orders.where(state: 'paid').find(params[:id])
    authorize @order
    @konbini = @order.plan.kitchen.konbini

    @marker = [{
                 lat: @konbini.latitude,
                 lng: @konbini.longitude,
                 infoWindow: render_to_string(partial: "shared/info_window", locals: { konbini: @konbini }),
                 image_url: helpers.asset_url('konbini.jpg')
    }]
  end

  def create
    @order = Order.new(order_params)
    @plan = Plan.find(params[:plan_id])
    @order.user = current_user
    @order.plan = @plan
    days = @order.date.split(', ').size
    @order.amount = @plan.price * days
    @order.state = 'pending'
    authorize @order
    if @order.save
      redirect_to new_order_payment_path(@order)
    else
      render :_form
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
