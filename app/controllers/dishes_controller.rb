class DishesController < ApplicationController

  skip_after_action :verify_authorized, only: [:fetch_ingr]
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

  def fetch_ingr
    @name = params['dish']['name']
    @ingredients = params['dish']['ingr']
    @kitchen = Kitchen.find(params['kitchen_id'])
    @dish=Dish.new
    url = "https://api.edamam.com/api/nutrition-details?app_id=#{ENV['app_id']}&app_key=#{ENV['app_key']}"
    payload = {
      "title": "#{@name}",
      "ingr": @ingredients.split(',')
    }
    response = RestClient.post url, payload.to_json, {content_type: :json, accept: :json}
    @info = JSON.parse(response.body)
    @calories = @info["calories"]
    @labels = @info["healthLabels"]
    @fat = @info["totalNutrients"]["FAT"]["quantity"].truncate
    @carbs = @info["totalNutrients"]["CHOCDF"]["quantity"].truncate
    # @sugar = @info["totalNutrients"]["SUGAR"]["quantity"].truncate(2)
    @protein = @info["totalNutrients"]["PROCNT"]["quantity"].truncate

    respond_to do |format|
      format.js
    end

  end

  private

  def dish_params
    params.require(:dish).permit(:name, :photo, :calories, :fat, :carbs, :protein)
  end
end
