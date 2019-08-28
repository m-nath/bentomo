class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :uikit, :uikit_kid]
  SAMPLE_NUM = 8

  def home
    @kitchens = policy_scope(Kitchen).sample(SAMPLE_NUM)
    @plans = policy_scope(Plan).sample(SAMPLE_NUM)

    if params[:search]
      query = params[:search][:query]
      @tags = params[:search][:tags].reject(&:blank?) if params[:search][:tags].present?

      if query.present? && @tags != nil
        @kitchens = policy_scope(Kitchen).global_search(query).tagged_with(@tags)
        @plans = policy_scope(Plan).global_search(query).tagged_with(@tags)
      elsif query.present?
        @kitchens = policy_scope(Kitchen).global_search(query)
        @plans = policy_scope(Plan).global_search(query)
      elsif @tags.any?
        @kitchens = policy_scope(Kitchen).tagged_with(@tags)
        @plans = policy_scope(Plan).tagged_with(params[:tag])
      end
    elsif params[:tag].present?
      @kitchens = policy_scope(Kitchen).tagged_with(params[:tag])
    else
      @kitchens = policy_scope(Kitchen)
      @plans = policy_scope(Plan)
    end
  end

  def uikit
  end

  def uikit_kid
  end

end
