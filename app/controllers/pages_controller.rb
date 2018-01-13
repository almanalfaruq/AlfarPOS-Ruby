class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @order_id = set_order_id
  end

  private

  def set_order_id
    @order_id = SecureRandom.uuid.upcase
    if Order.find_by_code(@order_id).nil?
      return @order_id
    else
      set_order_id
    end
  end
end
