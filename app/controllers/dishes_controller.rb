class DishesController < ApplicationController
  def new
    @kitchen = Kitchen.find(params[:kitchen_id])
    @dish = Dish.new(
      kitchen: @kitchen
      )
    authorize @dish
  end

  def create
    @dish = Dish.new(dish_params)
    @kitchen = Kitchen.find(params[:kitchen_id])
    @dish.kitchen = @kitchen
    @dish.kitchen.user = current_user
    authorize @dish
    if @dish.save
      redirect_to kitchen_path(@kitchen)
    else
      render :new
    end
  end

  def dish_params
    params.require(:dish).permit(:name, :photo)
  end
end
