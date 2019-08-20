class PlansController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @plans = policy_scope(Plan).order(created_at: :desc)
  end

  def show
    @plan = Plan.find(params[:id])
  end
end
