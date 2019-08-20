class PlansController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if params[:query].present?
      @events = policy_scope(Plan).global_search(params[:query])
    else
      @events = policy_scope(Plan).order(date: :desc)
    end
  end

  def show
    @plan = policy_scope(Plan).find(params[:id])
  end
end
