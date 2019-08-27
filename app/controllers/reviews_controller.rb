class ReviewsController < ApplicationController
  before_action :set_kitchen

  def create
    @review = Review.new(review_params)
    @review.kitchen = @kitchen
    @review.user = current_user
    authorize @review
    if @review.save
      redirect_to kitchen_path(@kitchen)
    else
      flash[:alert] = "Something went wrong."
      render "kitchens/show"
    end
  end

  private

  def set_kitchen
    @kitchen = Kitchen.find(params[:kitchen_id])
  end

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end
