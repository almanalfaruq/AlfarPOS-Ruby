class PagesController < ApplicationController
  before_action :authenticate_user!
  def home
	  @order_id = SecureRandom.uuid.upcase
  end
end
