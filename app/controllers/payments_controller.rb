class PaymentsController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:new, :create]
  before_action :set_order

  def new
    @konbini = @order.plan.kitchen.konbini
    @user = current_user
    location = Location.find(@user.default_location)

    @marker = [{
                 lat: @konbini.latitude,
                 lng: @konbini.longitude,
                 infoWindow: render_to_string(partial: "shared/info_window", locals: { konbini: @konbini }),
                 image_url: helpers.asset_url('konbini.jpg')
    }]
    @user_location = [{
                        lat: location.latitude,
                        lng: location.longitude,
                        infoWindow: render_to_string(partial: "shared/your_location_info_window", locals: { user: @user })
    }]
  end

  def create
    customer = Stripe::Customer.create(
      source: params[:stripeToken],
      email:  params[:stripeEmail]
    )

    charge = Stripe::Charge.create(
      customer:     customer.id,   # You should store this customer id and re-use it.
      amount:       @order.amount_cents,
      description:  "Payment for plan --#{@order.plan.name} of kitchen #{@order.plan.kitchen.name}",
      currency:     @order.amount.currency
    )

    @order.update(payment: charge.to_json, state: 'paid')
    redirect_to orders_path

  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to new_order_payment_path(@order)
  end

  private

  def set_order
    @order = current_user.orders.find(params[:order_id])
    authorize @order
  end
end
