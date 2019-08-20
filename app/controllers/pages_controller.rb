class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :uikit, :uikit_kid]
  SAMPLE_NUM = 6

  def home
    @kitchens = policy_scope(Kitchen).sample(SAMPLE_NUM)
    @plans = policy_scope(Plan).sample(SAMPLE_NUM)
  end

  def uikit
  end

  def uikit_kid
  end

end
