class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :uikit, :uikit_kid]

  def home

  end

  def uikit
  end

  def uikit_kid
  end

end
